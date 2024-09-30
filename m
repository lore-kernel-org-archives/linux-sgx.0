Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0440862
	for <linux-sgx@vger.kernel.org>; Mon, 30 Sep 2024 08:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727683541; cv=fail; b=XNwE8TbcGpvmr93J7eCjn9nnlLujoy3q3Y8TzjDlf+LpWo3akD2iBYnsjTDG4RkausQSiIcdS9FrjB9+yhOn8AhK7++VSjEBYSdFxAviDzrvzQgTcNgjUKyg8G+Bg7bwYJ66crnGqZyJz2Win/liG5sP+hGXYR/wdG9fAe9x2MY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727683541; c=relaxed/simple;
	bh=A+h+um5X6FCb+45JIXEr3Nfi7K9lP1wk4SuGUuWMo60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L9nqioqXMalVL0+aA7syANj6zCGlUMR4q9OeBspsgOfbrvuhGbP69J5o9Y7F8OuJ8lB4ZUNMZGAPxMg03goIHRz5M8sQzko79eAyfLwgWVDlm+9nrv2sRcryoe//sPNT5vRs+iHOdsQq833tUvauOq8xwu+7a9DrZJPw3fRuijQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PFB2z+dW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hhO2cOFm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PFB2z+dW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hhO2cOFm"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48U2tpK2024074;
	Mon, 30 Sep 2024 08:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=dNBdvStB5meuVmX
	b1OIzXklIIyKSGIYJCpX8jrlwyjQ=; b=PFB2z+dWhbebk6Da2+laVGligGZxKl4
	wJceH1v1EVvbWhZDUOwchW17L6pkHfWVqAtfKSAxtSgKsfBM6yzD9bKlXTXs8Ubb
	to0tCSaJZt5JkYFwbYisbMlqim1dOi1ld91Vkr3N7k5DIKY+DMyJ9LoxFFBv/S+l
	cHxaWNRG4zK6QL8WdBRzcd0KKXuqBwokPjyU4bW3P1iw1uvyN9DCAGzcREFu5p2o
	ynFbcgkgG4x5yBn9Xr/JLEgtPrPm55ZTJUJd2rLOS68yYNp5igJ6J+lXww0FB9oS
	3YlGapLeE6LWTELYmhmYkziUirXwMHzIepcL0uDbcm+qCEa46IGy8Hg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9ucjn6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Sep 2024 08:05:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48U61xAo026229;
	Mon, 30 Sep 2024 08:05:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x885qke2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Sep 2024 08:05:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMcrrUldSbceF6ikZtq5djdqwcK4ZtPUXPfo2fwk1IfnSJMTdbCtN2EjUJbTgsRveYxGH2RQqVwq452Fmi0QdckwxfdhSHvcuyucjl+uOaim8jVn59RJX/orx+oLiQNhs98EE8LZwLmsGJJ23rA3mZFweURaaGxDHTofVQwHKvmXbx6Z6z2IVUq1fJ83qSlKxIe9YgOAywVIbfV3oZElSe4bt1dg+nMuumPzVJqDF/3Wi+/GmMp/ZdFtJeVi/LwxIHTDHD107JnnMGyCasPTIJtNhpHLX16gWC7xO5VHsLjt+V2SUWWwcq2LQM1+Mhuijnx1lCn2MudICoxGEkKwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNBdvStB5meuVmXb1OIzXklIIyKSGIYJCpX8jrlwyjQ=;
 b=eq1R6q3UNsm27+4V5ADlgy6vRs61/xejuqRwRM68HtrWeeJdadx6OaSxtrrlBPprjUHzOz4gfNn69Immx2Gm6cWkQKGX/QVJRgE6+IEmw7L7AMDOgtAyj7AP+eBc6hfWRWGMfNZDh9AnVitVN2Mjd8wA3Q8eStF6egwQJbNAZkjvESapk8PLSb4NtgVNux0hQiXyRvF8bLzr9s5Jyy2Zp+oSxdQxgPEdwF6AoQUibzcIuc33tPOdIryW73aMY4S0D2ZHKOKiCeR4+Pv457gA8zBrazi+U2SK2NFX1xh4c6sBMIf+sRMOaeLtNgk/9E2JPrcSQSloEPd4gmVid0POPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNBdvStB5meuVmXb1OIzXklIIyKSGIYJCpX8jrlwyjQ=;
 b=hhO2cOFmi8XgCCiEZ1m13U2EMaxy9NwfTmig5jr/pR5xsFRuDlW5vAn9c72Q4+EHis+EQ0UfNpStELXSXF0aePTT1UNDoTxZeKc95XD/X25x+i3xjpjzG+9uq1saQpct6bZp4GTlITZCKWDAU6Binf0spBnXWfYlmE3dnNzdU+w=
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5)
 by IA1PR10MB7418.namprd10.prod.outlook.com (2603:10b6:208:445::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.14; Mon, 30 Sep
 2024 08:05:23 +0000
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e]) by SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e%5]) with mapi id 15.20.8026.014; Mon, 30 Sep 2024
 08:05:23 +0000
Date: Mon, 30 Sep 2024 09:05:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "Huang, Kai" <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, linux-sgx@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: VMA merging updateds?
Message-ID: <4ed9e4bb-5daa-4241-863d-4bbe923a7ffc@lucifer.local>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi>
 <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <2ba91a26-71b6-4150-9d8d-d5517d316808@lucifer.local>
 <D4J4L636HVPC.QH7CETQ7SGVN@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D4J4L636HVPC.QH7CETQ7SGVN@kernel.org>
X-ClientProxiedBy: LO4P123CA0143.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::22) To PH0PR10MB5611.namprd10.prod.outlook.com
 (2603:10b6:510:f9::16)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_|IA1PR10MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c99305-86e1-480a-5ee5-08dce126a24c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FXibdDPqkD/PvmyHi98Fy1FZkJcXmRTya93UIA/t5uirHbBIqzUpodKgBqH8?=
 =?us-ascii?Q?hQXZlZ5hDUh8q1UBXDdGJtYaCkok2AN/oKM7RJHbHN1OL9UtfNWN9fEDPJKC?=
 =?us-ascii?Q?8hhOT9NpZHyX4l0QssO6/gCnexSPZ7sFBoLFA2DfkJCmgTSLW/Y1tUkC0blS?=
 =?us-ascii?Q?BCV6RdK6Yx4yylteUzzhzQCNcbwiZtMpC4dKRIAnIbGFigA3h/blJA47wdyY?=
 =?us-ascii?Q?8GF1x97yPNBjp3jOMCS43smrmdT06OKHyO6udsLEhdB+L00tb/YhnNFiCpOV?=
 =?us-ascii?Q?i68MNNUgXTBpGJZvuhBoY3/hYRosj1FhJQ85yrf9lhRhl+RrDlRtL0KQuNgh?=
 =?us-ascii?Q?y3DC7Fh1O83DsfPsJiyhabyO+TkxS5Ntjd5A4wMxW/XiWojPfuwDnQVCJjUJ?=
 =?us-ascii?Q?VcmPyJJ1IQDbJFmUr8gm7nZmRe2GSw3zxSwDbaKHsY5vfTm6g8TSX5GU0Cok?=
 =?us-ascii?Q?QdrINROolE4VkS3M6dC+Ww3sUtaQDKba4zDWyogBzEyzDZdBZKv1q3Rj9RIB?=
 =?us-ascii?Q?A0r76RIGre7VN+0DOCy8ZUV4IDPzKjRpKqiQultQ/uBrYTIVCJwh3PUCYRzG?=
 =?us-ascii?Q?J5klWgfTHbyVBCE5ri/qh9Fwr/XvuUzK+B5ea5WUpJnFLSXXJoxLSEGx9j1+?=
 =?us-ascii?Q?ZqJJHY41UH99R+ac7IzRhbC9uA4uvnp5DrewYCGkCnpD+mrKiMmYL7VcqGGy?=
 =?us-ascii?Q?1HGo0f54Idpmt3a+YBSaWt1Hi5VQVZJWCai2BBvUck/VMd8QrQvkxFIyGd/A?=
 =?us-ascii?Q?ysAEIPiLro2XaI+tPF49XeZKpI5/p/kxuCTFFBAfaNtN3oRaYjCbHovJXZps?=
 =?us-ascii?Q?bRoTbbIAe8Nc7MhQiGZLxjjjGhJhOxuIh2ugEt1Gmz1NP2/6XCLhhn9TgnhZ?=
 =?us-ascii?Q?xjSE8oJUX5cZHgfLR5NnAoxNYaPzov6SJuO1RIejRwbxoBra1z5l5h2GAjEl?=
 =?us-ascii?Q?ZdVj4pAYvNBv1RDhdYKyqDmfw2wHXe68N/0Fk/JZvIoSCaFgACJRCKNXnjcx?=
 =?us-ascii?Q?TcSDqVVk8Fj6J8Qd0tOXs9c02eQXu6LxYbt8+lBv09g41bi+Ofl3BdvHc0C3?=
 =?us-ascii?Q?WiXo7mbQis62GIgU/Cu/QP/cySe4/bKvYvJO6sFvI2+1R6C52ta/qfcsMPJf?=
 =?us-ascii?Q?omNWfSTlboP8QC+TWXw/LHGxV/9lyWyuLC+pEk+k+mm5hbQhDLqsqgCkGmin?=
 =?us-ascii?Q?UrdQ+5OIC90EUYqdGvjNGTOzQfJ2xrAYnVgtW04Yu+dDiCjCeJSmhcErqeoG?=
 =?us-ascii?Q?Wmpw95La86Az9CEYRpMSJhFXtBLfGuGe8lwq3H2hO8bqOAGVXIYkgYbtbKUY?=
 =?us-ascii?Q?xw8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5613.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ud8SS6AYWInDtQVz/b+bY1KpysIqVvOqnh9SYinPqGqimhSrzFFeGM7/g1kn?=
 =?us-ascii?Q?goqNpfTCp+gz42ANwyBOfiGduKHVlr02KdSqe9+pcxJwmj3UuIctjuEVeumj?=
 =?us-ascii?Q?z/Q1BOCy1UOAtam3k6YZIPhorKsCTEBYEa8YrBS8dLpvBbNLmce2h2gP249f?=
 =?us-ascii?Q?SF0cmUT7plF9J11ejvi29T1fN+Blv1YQLNWykoH1HUgNN3ZyS6A0Rnbv1FtB?=
 =?us-ascii?Q?cprrd1GvSkgja+GsYM9Yr69m4NeItAfYJbBAOZv2gSf0FqPjM+qLveBH1+J4?=
 =?us-ascii?Q?BbRIe2buE8+Yj1T0jhQXaRFt1qJkGU0wkZbsl4+doAxRSMWuh2FC+6nVwCyP?=
 =?us-ascii?Q?OYDY0nxHmD+F98pYAi4OZitSFvckIcjCIkU+or8P2q8UkZGDM4bLX49Brwow?=
 =?us-ascii?Q?hOIVGTeoUp7ZjP0pIKdv2mkuLQLYM+GrIcjQKSkJNI6qKP3xQg5ldFoMqIfz?=
 =?us-ascii?Q?NLlvIjCAIAAlJanw3js5QdypdAvBm9ypfTwrJQ5z1xtFXhmXZEWf0tNnxVRK?=
 =?us-ascii?Q?GgvAYjas3dGx+VRF+sAQCYYy56THO4+Owre0pDSYfWaO2cZfpp5wnw6ALy51?=
 =?us-ascii?Q?KjXRwZCq2FkT5a0S/XHo7lxIuA7WZRBB4n69Nqrmi0Xskn+hLzhHYYBPiS4L?=
 =?us-ascii?Q?FfjGklk7c7lDhByBnn5/ZW76LzGzrbsFU0PfQtTxavzS2R9AfzNiiGvrPAeR?=
 =?us-ascii?Q?Eb/Tm6313uVQ3CsVcB5s4oVbK/CRIQO0JOBgquVCBMNB+vlqdhhXimYRbDMx?=
 =?us-ascii?Q?+TIETPQ406rtq0zWziZS3G/QigDI2OVXKANFs9Ob+e4eO4zujKAhBJBUSHew?=
 =?us-ascii?Q?FwOXY4AckYwY6Jf133GCm3jhYJ53imZ4vZq4dL4KgFw03maXicD/RQvldn7u?=
 =?us-ascii?Q?MC3M3NNGcUYxgPXceuQ+YxHL/egqa6ty/e9lvVnbHo+71oWVzqQldrsXbvJu?=
 =?us-ascii?Q?/Cxz0fccI774eIicB3UcaBGfKGWOPo4m+J0AutTwEh1671hDvBndhd8lb67p?=
 =?us-ascii?Q?1YYf5su+1LndvB5nl1bPgLB98D9tggWdg3MJlS2Z9QJYbVPy63ZxnmWfbojx?=
 =?us-ascii?Q?PKN5RbY76SnnlH2GWoWQD2k3ARUrf4XC/kFrAehXe9D2IfSKflKrxEASOoF+?=
 =?us-ascii?Q?zI18w1Q1c8BBlMHtgg25YZFBWqIgvTbSwl4gBgmb05id0AXM0sbZNvvhuImQ?=
 =?us-ascii?Q?71dOS41UTZnORJiANm1P4Fej5c48P1NQL7FcxWriRYBGqh9Al7G3MX1bbTOL?=
 =?us-ascii?Q?R48ShITNPu25WlCmaBBmfoDHkBwmU5FTLCJ+66lhNFhk4HhCRrckzclejUlT?=
 =?us-ascii?Q?x4AY7fFmTy6ocRvMXjN0yAKCM3zdt0NGOCJbCEpxh0IdszCWZTfIFWQqZ2hF?=
 =?us-ascii?Q?TMqqm/9qXSger3jTTjj9knZGEINydbO5unLFTuehgMkE0jkDfAWivA7HefdF?=
 =?us-ascii?Q?EeA5fHvjB/lvRvVBoaiA7vbg4z7j/R2AsS/xgLe0QaV7U3mWfQRfwxPIj9w9?=
 =?us-ascii?Q?wybWZ7V4EvlkdM0HPIdp6tBsZvC4wOF9k2VXZhNJRj1q/jKm9lHola11GAqb?=
 =?us-ascii?Q?l/BWJdg99e8rf39vKaDVR3AlJvPRnqtJX6+vnscZAezOB+GH4SZZm+DpMngo?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q2r8ZtjXFSPwL8pbV3HJnKLmopE4etkUhFTD3A8Db++og5Nw9cld4Ol3OhGwQ8qsC6Vh0F6yDvIH58sh53A1hrRpBqrjnBdmUogfNBm+AD8/A0e/wY2IcFd0+TXWLHjbqzwPjCDesAg9bAR5RagSAlaVsEhP92R1zHDoaQCsQXKV0llVd04WnZjWrMD1aQjUQtawwJz/lfsXo7C7dMaiE33W3EkI6CqOWSedVyrc0HCr32nS+4isSpe1ddOZOx/cs2vqf/ogBbvDypxQf2dGtH2D2QdtzkoxG/L7wzcEoxxK9L7U5KKQ12wgyu+cr9hdjuq3da0YI+thtBUfQVpHL0Rh2ZgpnCB0wah/1HwRVUHc/EuScbi6HBs+p7h2M26MMdgspLu/25s6OHAaqxFIosaabg4MK8aEYexaeYPKtI+A8oP4irH2UF52kU+hwWep17MPLsVXNHOVigKrP+Iw4kCUU85ThZWyUI576ofyLgGBUTS/NX7d5GaOVQ+UIkmA5JN2wnY5EEUYFWqCSuxTdkoJQOhpBA0Ll7MFTB6hBdScvm2C98pAGVYAQBXxW6qKGnqvKgzg0HwhrLeG6O9aII46NgUPsVcvXmmH8skEC1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c99305-86e1-480a-5ee5-08dce126a24c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5611.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 08:05:23.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4dRmV+FYevkSiZ+dwMMTs9q+Qh6GnY9cMifBtNZOkz/Kg35IGHUdUJAZ3o5VzZUc2kOacPnl8pYdm/6CRKajfL4EZH/teZM6T99TYvgAfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-30_07,2024-09-27_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409300057
X-Proofpoint-GUID: Zt1i-WBEihIb9pYOQXplkc74PkMkxGMp
X-Proofpoint-ORIG-GUID: Zt1i-WBEihIb9pYOQXplkc74PkMkxGMp

On Mon, Sep 30, 2024 at 01:36:06AM GMT, Jarkko Sakkinen wrote:
> On Fri Sep 27, 2024 at 8:39 PM EEST, Lorenzo Stoakes wrote:
> > Jumping into this thread mid-way to give my point of view.
> >
> > On Thu, Sep 26, 2024 at 12:07:02PM GMT, Huang, Kai wrote:
> > >
> > >
> > > On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > > > On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > > > > > On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > > > > > > Hi
> > > > > > >
> > > > > > > I started to look into this old issue with mm subsystem and SGX, i.e.
> > > > > > > can we make SGX VMA's to merge together?
> > > > > > >
> > > > > > > This demonstrates the problem pretty well:
> > > > > > >
> > > > > > > https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org/
> > > > > > >
> > > > > > > It was result of brk() syscall being applied a few times.
> > > > >
> > > > > Briging some context here. This can be fixed in the run-time by book
> > > > > keeping the ranges and doing unmapping/mapping. I guess this goes
> > > > > beyond what mm should support?
> >
> > The reason you're seeing this is that the ranges are VM_PFNMAP (as well as
> > VM_IO, VM_DONTEXPAND) , which are part of the VM_SPECIAL bitmask and
> > therefore explicitly not permitted to merge.
> >
> > VMA merging occurs not when VMAs are merely adjacent to one another, but
> > when they are adjacent to one another AND share the same attributes.
> >
> > Obviously for most VMA attributes this is critically important - you can't
> > have a read-only range merge with a r/w range, it is the VMAs that are
> > telling us this, equally so if different files/non-adjacent
> > offsets/etc. etc.
> >
> > For these 'special' mappings each individual VMA may have distinct private
> > state and may be tracked/managed by the driver, and indeed I see that
> > vma->vm_private_data is used.
> >
> > Also SGX utilises custom VMA handling operations for fault handling and
> > obviously does its own thing.
> >
> > Because of this, there's just no way mm can know whether it's ok to merge
> > or not. Some of the attributes become in effect 'hidden'. You could map
> > anything in these ranges and track that with any kind of state.
> >
> > So it's absolutely correct that we do not merge in these cases, as things
> > currently stand.
> >
> > > > >
> > > > > I thought to plain check this as it has been two years since my last
> > > > > query on topic (if we could improve either the driver or mm somehow).
> > > >
> > > > In the past I've substituted kernel's mm merge code with user space
> > > > replacement:
> > > >
> > > > https://github.com/enarx/mmledger/blob/main/src/lib.rs
> > > >
> > > > It's essentially a reimplementation of al stuff that goes into
> > > > mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > > > which map over existing ranges were working correctly, i.e. was
> > > > the issue only concerning adjacent VMA's.
> >
> > mm/vma.c's vma_merge_existing_range() and vma_merge_new_range() now :) I
> > have completely rewritten this code from 6.12 onwards.
> >
> > > >
> > > > What I'm looking here is that can we make some cosntraints that
> > > > if satisfied by the pfnmap code, it could leverage the code from
> > > > vma_merge(). Perhaps by making explicit call to vma_merge()?
> > > > I get that implicit use moves too much responsibility to the mm
> > > > subsystem.
> >
> > Merging/splitting behaviour is an implementation detail and absolutely
> > cannot be exposed like this (and would be dangerous to do so).
>
> I can believe that (not unexpected)
>
> I've been doing some initial research for possibility to integrate Enarx
> (LF governed confidential computing run-time) with
> https://github.com/rust-vmm/vm-memory, which is pretty solid mmap
> abstraction, for which at least Paolo Bonzini is active contributor.
>
> Enarx is multi-backend supporting also VM based private memory in
> addition SGX. It has some a bit degraded parts at least SNP interfacing
> code that need to be fixed. So I'm now just scoping what needs to be
> done make it fresh again. It is just a leisure time sudoku just to
> recover a rusty codebase whenever have some idle time.
>
> >
> > However, I think the only sensible way we could proceed with something like
> > this is to add a new vma operation explicitly for pfnmap mappings which are
> > _otherwise mergeable_ like:
> >
> > 	vm_ops->may_merge_pfnmap(struct vm_area_struct *,
> > 				 struct vm_area_struct *)
> >
> > Which the driver could implement to check internal state matches between
> > the two VMAs.
> >
> > It's nicely opt-in as we'd not merge if this were not set, and it defers
> > the decision as to 'hidden attributes' to the driver. Also we could ensure
> > all other merge characteristics were satisfied first to avoid any invalid
> > merging between VMAs - in fact this function would only be called if:
> >
> > 1. Both VMAs are VM_PFNMAP.
> > 2. Both VMAs are otherwise compatible.
> > 3. Both VMAs implement vm_ops->may_merge_pfnmap() (should be implied by 2,
> >    as vm_ops equality implies file equality).
> > 4. vm_ops->may_merge_pfnmap(vma1, vma2) returns true.
>
> OK strong maybe see what I wrote below.
>
> >
> > At which point we could merge. Note that the existence of .close() could
> > cause issues here, though the existing merging rules should handle this
> > correctly.
> >
> > I _suspect_ from a brief reading of the SGX stuff you only really need the
> > enclave value to be the same?
> >
> > So it could be something like:
> >
> > 	static bool sgx_may_merge_pfnmap(struct vma_area_struct *vma1,
> > 					 struct vma_area_struct *vma2)
> > 	{
> > 		/* Merge if enclaves match. */
> > 		return vma1->vm_private_data == vma2->vm_private_data;
> > 	}
> >
> > Since you seem to be doing mappings explicitly based on virtual addresses
> > in these ranges?
>
> Yep, so this is how it works now that I revisited the cod ea bit:
>
> 1. Enclave is a naturally aligned static address range of pow2 size.
>    That is mapped first and everything happens inside. It is mapped
>    with none permissions. With opcode ENCLS[ECREATE] this range is
>    connected to a singe enclave.
> 2. With enclave or actually even SNP VM then internally has small
>    engine and database that implements mmap() call and calls back
>    to the outside world with a MAP_FIXED range. So actually in all
>    cases my mmledger book keeper is in all cases needed. And it
>    is needed to define what is expected from run-time.
>
>    It must happen this way because of a distrust model. Without
>    going too much details enclaves can set requirements for page
>    permissions cryptographically and have structure (enclave
>    page cache map) for this. Thus enclave (or SNP VM) leads,
>    run-time follows that by delegating (fixed) mmap() calls,
>
>    In practice the enclave will #GP if memory access is made
>    with unexpected permission, even if page tables would allow
>    it. In theory you could even just plain rwx map the range
>    and base only on EPCM but in practice matching the page
>    tables is useful and adds a bit defense in depth.
>
> With SNP things obviously work correctly because it is just a
> fancy VM with weird extra shenanigans.
>
> With SGX things are fixed up by allocating a static heap and
> never translating brk/sbrk to any syscall. Then for regular
> mmaps() it just I guess hopes that user space software uses
> it wisely :-)
>
> >
> > I could look into RFC'ing something for you guys to test when I get a
> > chance?
>
> So I got some ideas I could try out after reading your proposal and
> restudying work I did over two years ago :-) I think it makes sense
> for me to try to see how much I can improve first.
>
> With pfnmap what did happen when you have a fixed map let's say
> from A to B and you map from A to C where C > B? Cannot recall does
> this success. Right, and as said vm_close() does not exist.
>
> That could be used based mmledger to overwrite the old VMA. Or I
> could do pro-active unmapping.
>
> mmledger could tell "what changed" i.e.  provide syscall parameters for
> 0-2 munmaps and mmap(MAP_FIXED)  and ask run-time to execute those
> instead of just mmap(MAP_FIXED)
>
> I need to improve that crate anyway because I realized that you need
> something like that to any trusted execution environment because they
> reason what they want from memory :-)
>
> So I get on this first and come back to this lore thread later when
> I have some more experience on the topic.

OK cool let's revisit this when you've done that.

I think if you did want assistance from VMA merging what I delineated above
is the only sensible way forward, afaict.

>
> > I'm guessing the problem is a concern that a map limit will be hit or VMA
> > memory usage will be a problem? If not it may simply seem ugly...
>
> Yea, so Enarx can take any software compiled to static wasm program and
> put into a protected environment. It has a syscall shim and wasm
> run-time and loader when it launches. If the application uses mm
> syscalls like a good citizen it should not blow up VMA list but
> that ofc is based on good faith ;-)
>
> [1] Only for completeness:
>     https://github.com/enarx/enarx/blob/main/crates/shim-sgx/src/heap.rs
>
> BR, Jarkko
