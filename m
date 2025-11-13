Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07532316901;
	Thu, 13 Nov 2025 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060975; cv=fail; b=XuQtwxXMJoqwHSPzRYH5d4/c1ShduH4eZWOxBXnWUZ7hInKLEfVkiHGBZezh/JW0ml2e5pEWYcoEcOHbTfBNyBpWgIgIycGIgIOEKc5OhhrKl3eKi376U4fIW+XXU1c+K1WNKLR+QcZTowSwhS08QGnlgrV5AUMIoomWKUcne3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060975; c=relaxed/simple;
	bh=aGGt8UGTjsDkGJDd4temYeoGQ3NYMNCGKZHjB/fAsGo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sR/otja0bmZ5rkf+G/GNTBlEo13RAZNneDH1FtK78JBvcixxTDVmyxJsvnQjpl/MxgxgpTB123uZmnjghUOGlrN1U2G79KHex9HITRIjd6cm6qOn9Y8SqjPHmMIgjht2Dd8eqcOUlgrb2pOFZCYNeY7mWwUfCqBbzOb4PnoEGbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=G7+O8DDs; arc=fail smtp.client-ip=40.93.196.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="G7+O8DDs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkxTDzCa3ZFferMAyOQ6T+FzLqLpg6tjwQcze3D3lvk6K6zSjbHQHGVriHUQWCpcbftZPxm4ZVPcpctvwj/jeq7jFA68BnNK9cbc3Ol8pYt1PgDtem4azaLyvrjtNNQbeGV/e42DL5kFpaLzF9U7NawH1QN3Z3wok+fuFHYDHs1pfmB5wDja5v8/tafgWAbeUoUXTf4ttMFrwtDljvX/Q3q08PO+8oTsLPp9bXZ25LFg5dsvYtY3L4HxuPuMW8IoQ97WSJngKQgOj/ZQRw3TGCmNvHdkyAzoI1YUjapGNfhO/+4cC2Sn96pnAyJSCs3HHSaoixEe66kjbSzp0IySMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dl5ZgRySp20ietmMhtu5slV8e1Y54FxfjivipsL8Y9M=;
 b=tEMoCl0728lNqYOl4rHPwaamYfUUv4YMGRRXBBgp+byUz9BQQrOPbUiyYxYwM9vCHFK4dHhw7VejuVhRaCy9Tg232Sez+W4qOaj6VFn1WDqtpzH8XYUPXkSpLkuqkAdmq1M8skYdAJsiSavM1MYXbXsnkgJtLEvh7BR1NqtUgAJ5DrerA+VCD6j+nJOKAvIHd7swbRl8ydYDsed4xVzT+Kpz1orZEUe8qvDa6tffpZA6lQDMO49nCvNYxYSc+wGYyR2GCvnTrGrWunAHCuLfqdwx0jar77+W8gzebIJXAyzFJmPp4Nui9wbG7fVaNYIWNCe5iKRclqhJqMcs5j0Jpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dl5ZgRySp20ietmMhtu5slV8e1Y54FxfjivipsL8Y9M=;
 b=G7+O8DDscuIj2vC9Fh6y3Aqh8GJYrt9j/MaeiInQihcEJkiEA8wCPyRIxCBw4aDYwnCZ3lqdf1qms45yryAnrKKrIl728l4jnGtK3Qh0aHy6NwzsQNOjLlk6EMZ09P1TBrjHTd4Ri7CIkkZAVmH9vhtDYC/Y3NjciIWaJV1lkqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by CH1PR03MB8165.namprd03.prod.outlook.com (2603:10b6:610:2af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 19:09:29 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 19:09:29 +0000
Message-ID: <55128481-71e2-489e-a669-25b60dabb407@citrix.com>
Date: Thu, 13 Nov 2025 19:09:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK
 PHDRs
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>,
 Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>,
 Uros Bizjak <ubizjak@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112202258.1310754-1-hpa@zytor.com>
 <20251112202258.1310754-7-hpa@zytor.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20251112202258.1310754-7-hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0630.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::13) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|CH1PR03MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: ff05da97-0283-4376-d5c8-08de22e82bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V09GMWU4TkdSdFE0K1h6WW50WHhrclhPVG5rTkMzNTA2VWRFNEJSV2ZQU0Vx?=
 =?utf-8?B?cWtiMjlMZ25MKzBYVVZJUWFDVmIrckJ1dDA4emdzTE5yd2RQbmVSbWlwWUxB?=
 =?utf-8?B?V3BBL0ZOdUx4enNZSXg5Zm8yNXQvM3N0UU80WnJWeFJqbDlMR3NURFRydWpU?=
 =?utf-8?B?cGJzQSsvS2RacXJqNW9SU0tlYlB0TXZ6c0JZS0R1QkdVbzlUR2V0QUVnRWVN?=
 =?utf-8?B?ODF2MTc2NVV0TTBveHM0V0NtRkNDaUZyYkxvdXBzOUdzQlBCM2YvcFR5V1By?=
 =?utf-8?B?NkRiRDZRM1hQTWhHUXc2TXozdnE5TWp2U3VhMTFhZFNONDNXaHZ1WGdJSDhT?=
 =?utf-8?B?RmhJN09KZVFGWTM2UzZJejNud01oNFJuNU1QekExYkxPV21mb2kwaWlvRE5x?=
 =?utf-8?B?Zmx2aE95ZW92OGVtcURTVUh6SXpJYlc1cU1DRGNRRlFGK2Z0SXNsN3MyNzdZ?=
 =?utf-8?B?RUlHUEpHZi9lMHJNd1BXeVM0TGhlZzdvQkdUc0xKZG9CNW9ZbGpXNkhZV2l3?=
 =?utf-8?B?TS95Qm5aMTJwZWJTbE9HZmRFcDNxSllVWFkxcDUyNXlBVjFsRHRwU2ZrOXVD?=
 =?utf-8?B?NTMxeGZwMW1zaTlQdmFjbW84bVlqRThFd0gxeXVMUzVTdk9MTGdYL2hSVVMw?=
 =?utf-8?B?dzZvcWdsWFFGY3dPUHdua2RFNFNsR0dTVE5EK2dRMisySjYyVkNSamZ3U3lV?=
 =?utf-8?B?aTAzSVJJajNlWkFpekxEdXZMMFVWSUNucVVOWVhXV2U3RjJmTEJWUDlWUDd0?=
 =?utf-8?B?QUwwVXdZa1hVZXRCQjduVW9SQ3EzZGpYVExFRmZ0MVhacmNVajlkb0RNems3?=
 =?utf-8?B?UkxPdUQ3QUNkQkdnMGhBZis0SlZlSVorb09NTXNwRzdZMmtVNVMzUEpwWTZp?=
 =?utf-8?B?WlNTemIycENRRXpBR1lhL3UrZ2tYSVplQ05wTExzUFNMdUtQdWpicTBvVmlP?=
 =?utf-8?B?dHdaU1F2MmkrODd2Y012WUpDNUVYNjFkb1BGUHJhYXdFV0VDYytoaXdBVXBU?=
 =?utf-8?B?WnFiTGpPMlNLNUIxYXFUeG9uNTd0cE9lUWNudUlQNE1RMTU3WUd6ckVNRGU3?=
 =?utf-8?B?T25OeitLNE5VRFlGYXgvTjltQkVrdjl6NWxtTlh2Z1ZUNlJVU0J4cGlZbk12?=
 =?utf-8?B?QkUzRTk1OUxJZ1doK2JVUHZ5RHZjRFNzNGtnSFBrMkU5dys0ajJIQjFhUFpL?=
 =?utf-8?B?azhqbEltUVhzdi9VQ2Y2T2xCN2dKZVBrZEcrdjZKekxjeDJ1dFpJQmMxaEVJ?=
 =?utf-8?B?MHZiVys5OW9ickVVN1JBcUxySTNuOVBZZUJWcDRXM3VCNm5CVXBaTG4zODZo?=
 =?utf-8?B?NzBsUk8xL1dhZzFsZlBWeTloRGNRNFB1aTd3OWJDRC9TV1JOYVlPZ1Vic1E4?=
 =?utf-8?B?MTk0Q0EvaDNxbFc4U0JHOEZGbCtYMzRITmtZdUE2aDRnVXA0cUtqL2x3TEIv?=
 =?utf-8?B?TEJaZEcyU1BQNElEL3B6NDhDZ1dkMTE3anFRVDhheCtmTk56S0o1N25jazhT?=
 =?utf-8?B?TnEvdldxMVFraEU1bXJ1NnU2Sk1WYitBOFZNMGJYR0pzZXRNQ1pNWXE1NU5i?=
 =?utf-8?B?N3ovclp3RHc3dGIvUkVNbWgrNEY1aHNiQ2tsZVQ3NTNNbGxncWdodTRrbnQv?=
 =?utf-8?B?Mm1zT0ZrOHNNcHZkRWRhR1lnRlZCb2FYajJveG51SS9BMS9TUEN1L0hqc0xF?=
 =?utf-8?B?cXdqMEhVUUpaZ3JLY1B0RVk1RnlVV1p1TkhjTzk0U3FGMTMrV2VDOXgxcm13?=
 =?utf-8?B?M1dMVGt2OXNZUEdITjlPYzU5Z2tGUEVhN0g4R2xEdlJjQ0gvNFE5WXh0YmhR?=
 =?utf-8?B?YWhBRU95SUpaUlBCQkp5Q2xrMmczMXF0S1dnQ1FVUWRJeFFLSjJOdU1zZnk3?=
 =?utf-8?B?VWJnSitPL3YyNDlqUW5WS0RFU1VFQ1h0a0ZFbWhSenlkcVJvWUkzUkFXNU5H?=
 =?utf-8?B?K2xzY3h6Uk1zK2ZwVmRkTUN5ckozM3pJYXZpWkhPN0NLZ2Y5K2lZWG9XL0I1?=
 =?utf-8?Q?9kBZh8Lbs8opRAuGLgrSLOrV+Fd/H0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ako0U1Z1YjBRellUQkJhZWdmOXBXL1NYVTRoenNKU25XNkUybkg3UnN3V2dz?=
 =?utf-8?B?aGJuMXNaUm1nVDVvbXFSSXpXU25NKzgvWm53VllGNmF4QVdNZnNERXgydjZT?=
 =?utf-8?B?cVlKKy9ZSDlFU3Z6bVlmV1BqTCtaQWlNT1cxNVFjSzlPZWUxSTBLalk4Zmgx?=
 =?utf-8?B?Y1gzT1BhUUxjLzJ3RVpzM3pad3ByQkc4SVZXQWx0amN0SkRZVTFRVDdCZlg1?=
 =?utf-8?B?M21uM0w4NThsR085MjlZVldvb0VHeTdTRW9LRm5UV0pHY25XWVhJRWRENDhx?=
 =?utf-8?B?bGxobTFsOGExeDFSeHdTM3krYkoxWkdFdjR6aDF4akhhUm1xckxuMytpTElu?=
 =?utf-8?B?dXpxbXhZeVhaRmw2QkExSEhrUDluZ1Q3Y3h6NG9CczNzdnE0YjVnalFzcENN?=
 =?utf-8?B?bGxNNDJYRkVXblZXVURxbXMwR3U0dTI5SWNWQ0dzRUQ2eWRUSy9MU3lWc2or?=
 =?utf-8?B?V3JLaUh3ek9ZWVBtaDJEZnd4YTdVQWZOVkZtNnE5eFNMdlVLaytmT2dSUkNE?=
 =?utf-8?B?VENHZHVKdDZCVjVWRzlmTTZuemZNV3BnQzNvZ3VxRTdqY2FLa015a1lsRzFN?=
 =?utf-8?B?RDRFVExqYmF5MmJjcVZaT0Znc0pBbU1JU3pGbGVoZGlrNjlNVWhuWFBJZG56?=
 =?utf-8?B?QUFkSnQyc2ZieVFmYjJHZE9lZitjR2tMbUZZWjFiQWEyQkprck5YT1pwdHVV?=
 =?utf-8?B?alVZemFiTHdoMmRQL3FzeDhCNkI5cm0rZCt4WGVSSm5SNjZkaXBrS2pnYWJF?=
 =?utf-8?B?SDBLdFhBeEdmQTN0TWRVRkdMWUVCTlZUcENLZEUveEMvU0xEMFdBOFByT29D?=
 =?utf-8?B?VWJ0WThoT050aDlZYjJucFFnc2toWVBheXM5eml6OTZwNlBGSXhyaE5TWVBt?=
 =?utf-8?B?aElsVDZ3SnRUTk56YWw1SkxDV2F1Q243b3NoallTcHhwamdHU3JsTXZOTHhO?=
 =?utf-8?B?TjdSNkhSSjYwdThEZzNlbnVZVXZ6Y2RsQTRFZjZLbU1HNGg1Z3U5aS9ZWmFt?=
 =?utf-8?B?N3o0ODFUbXJkdFhxNHVFV2dTeUlqcVFqVEl5Ky91RXlNNFlsTE91Ym1LbHdS?=
 =?utf-8?B?Z3ZWN09KVkpBZzN5TDYvTVFnVlhjdHg2c054YWVoUEFXMmNoejRXaGhOeEQ1?=
 =?utf-8?B?U1JFVldrUmdrRERnY0wwWmlKaERoeWt0bTlmRzFZM2dPM21PSE5qSVZxS3dY?=
 =?utf-8?B?Vkt6c2hSOElqN2lKT1VsTk5KdVJ2R0NOdGFhNGVxSGtxbTBkUTlza1Mvc2JK?=
 =?utf-8?B?TjFtVUF5U2lSN1hDRTNES2ZlbXppV1VCM1ByYjA4d0VaNmlVb096cXZ3QlBU?=
 =?utf-8?B?eVdlcmdraUFLWDl3WHdEejF3dFNOMDB1REVrUGxkNkNqQXdBcDYySFNmTU5M?=
 =?utf-8?B?WGVNVHBhdXVSbGVHRERVUHUrVEtWeFg2M1JjKzZCa05Pa2VKVm5meHhkLzFV?=
 =?utf-8?B?bVJlcm1Fak9LaGEvTWplNDF3dXl1UzIvOVRRUmtGdndtOUQyRFhNVlVBTThu?=
 =?utf-8?B?T0lIMDJXVjNXR09XRWZBVjdhalVxVHJMWi9FaCt0ZXB1MEF5c1lCSTFSaWNS?=
 =?utf-8?B?SkdaaU5MQWJZbXRmYlJlSXc3QVA1Q2ltKzRzUlFhSndxb2MzRm5OeEYvaURE?=
 =?utf-8?B?Y3RYZDhCci84N0NUeUo3b01Vb2dNL3ZSZHNmdHlDOXFMOUVpMlBjN2RuajRG?=
 =?utf-8?B?bFhCaTI4d2dzV3dRYXcydC9BK2Z0b0xtdndFempld1YrUFdPVmFlWDhxR243?=
 =?utf-8?B?UVBTZTlNSEdDKzI5ei9VcXZPeVhsVm1ybDFEQ0p3a1htaTdlNC9xaXh4NmJD?=
 =?utf-8?B?N3ZnSUltYU5GcXZZdzJmQ0ZWSVBNb04xOHJ0VUxqcHFqaTFCUXByVG1HNTJH?=
 =?utf-8?B?SGJQY3oxSFgzYm14MHBBTGs0SXd5K05WZ0pzeVdUbzdDT0EvWXVSWUVZM3Bm?=
 =?utf-8?B?T1dpVU9EMzBkMWtUYmdhb0VLLzZKeXNKNm5jNXMzcmh5Y3J6dmdMNWgyNi8v?=
 =?utf-8?B?blBHNWg2ejM5TnVZUFdHTy9pdm45L3NNbUxoTGRLcnhpaUl6ejZVV2VpNEdv?=
 =?utf-8?B?RFNBMzUxcGNnalNqZHROM0I4akJtdDVtRERmaVBYTHdISktrbTFiZFczVFBt?=
 =?utf-8?B?c3JFUXRQTjdYeWVMWUdYK09USG1pd2gxQms3T3BRejNJRyt4Q0VyVVlZalJv?=
 =?utf-8?B?V2c9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff05da97-0283-4376-d5c8-08de22e82bbb
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 19:09:29.5937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWJOyWAe44xAXSza/+KMTAwFs4oUXABZQrM5DAkkbiNtiqOMyO9gRDt54TFnSHt0RKqwX358XRXpPVR7Ze6bZ74snoZlcKIKmun24FsweLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR03MB8165

On 12/11/2025 8:22 pm, H. Peter Anvin wrote:
>  arch/x86/entry/vdso/common/vdso-layout.lds.S | 51 +++++++++++---------
>  1 file changed, 28 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> index ec1ac191a057..696bacb99ed8 100644
> --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> @@ -26,7 +26,7 @@ SECTIONS
>  
>  	. = SIZEOF_HEADERS;
>  
> -	.hash		: { *(.hash) }			:text
> +	.hash		: { *(.hash) }		:text
>  	.gnu.hash	: { *(.gnu.hash) }
>  	.dynsym		: { *(.dynsym) }
>  	.dynstr		: { *(.dynstr) }
> @@ -34,7 +34,7 @@ SECTIONS
>  	.gnu.version_d	: { *(.gnu.version_d) }
>  	.gnu.version_r	: { *(.gnu.version_r) }
>  
> -	.dynamic	: { *(.dynamic) }		:text	:dynamic
> +	.dynamic	: { *(.dynamic) }	:text :dynamic
>  
>  	.rodata		: {
>  		*(.rodata*)
> @@ -45,31 +45,28 @@ SECTIONS
>  		*(.bss*)
>  		*(.dynbss*)
>  		*(.gnu.linkonce.b.*)
> -	}						:text
> +	}					:text
>  
> -	/*
> -	 * Discard .note.gnu.property sections which are unused and have
> -	 * different alignment requirement from vDSO note sections.
> -	 */
> -	/DISCARD/ : {
> +	.note.gnu.property : {
>  		*(.note.gnu.property)
> -	}
> -	.note		: { *(.note.*) }		:text	:note
> -
> -	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
> -	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
> +	}					:text :note :gnu_property
> +	.note		: {
> +		*(.note*)
> +	}					:text :note
>  
> +	.eh_frame_hdr	: { *(.eh_frame_hdr) }	:text :eh_frame_hdr
> +	.eh_frame	: {
> +		KEEP (*(.eh_frame))
> +		*(.eh_frame.*)
> +	}					:text
>  
>  	/*
>  	 * Text is well-separated from actual data: there's plenty of
>  	 * stuff that isn't used at runtime in between.
> -	 */
> -
> +	*/
>  	.text		: {
>  		*(.text*)
> -	}						:text	=0x90909090,
> -
> -
> +	}					:text	=0x90909090
>  

Almost all of these hunks look to be whitespace changes only.  Was that
intentional?  It certainly makes it harder to read.

>  	.altinstructions	: { *(.altinstructions) }	:text
>  	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
> @@ -87,15 +84,23 @@ SECTIONS
>   * Very old versions of ld do not recognize this name token; use the constant.
>   */
>  #define PT_GNU_EH_FRAME	0x6474e550
> +#define PT_GNU_STACK	0x6474e551
> +#define PT_GNU_PROPERTY	0x6474e553
>  
>  /*
>   * We must supply the ELF program headers explicitly to get just one
>   * PT_LOAD segment, and set the flags explicitly to make segments read-only.
> - */
> +*/

This looks like it wants undoing too.

That said, I do strongly agree with the reasoning behind this patch.

~Andrew
