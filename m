Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.2.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795383512;
	b=v5HaIaq3VxW98fOVWk7IR4P/0GKXcJ28TIPVmVsanHm0oj4xJJZ7DcQXWsFxtOF/6EUM
	 xxAEFwgGT1OrJJpB5Hijv1LI5Rclp/IPmVSSl3PaNbbxN4i9y5KFY1EZFm+JTePZNxAbU
	 wiKGAOzlXTOmGrWgDTIfkHqG0HMw6eWMJPbHzooGKBTnkFMjXHBauuDIoJ2CY+eOV2Wwf
	 vOZCUgbMC7TRyfyWq/V0gK7opDMw3ifStTpFYdxUiX+qwnuOA3GEX4eqkqy6rMdHiEvRy
	 HA98SMS+F0AmHwjpQEs8ZOLnYb46iSTkPtteZsJbZ0cRxvfwBR0xNt0n6fQtqccZ3+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383512;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=uI6N0yy3nE3r3l3B3HOfIN6e/2icGcmSb0OOdqzMBF8=;
	b=Y+hQWhHLdVQhnROdFvxe+/nlbld9x1Rdyi7r/RGzFxSID321QkP2vIP5VDGzrni976G0
	 hQNGOT0oeOaUrqp/s+zc0D3xJ0pPprX10PhFzUKK53stm3Hs7oDYzlPF1EkLmCXcWoDDG
	 G5FTcmhUuZxI5KYP7ejZUp9WwS8xFPOnRZZAzDCdZmDSUMGuvNIn1OPH3dINZstV9REXW
	 WE/XcPWzmhQnF/KL5QB40lIXaLxiSWmr6R//L3CGGgTzW5StJzeOiVIxrVssldB5ooW9c
	 cXWfpOFur/sWxc8AMpJM3g2at3d01ychygteMP+p2BhFBik2UaVvVQVMV6//Frs2ggw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=qBqDzVZ6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.2.48
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012048.outbound.protection.outlook.com [52.103.2.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB45606A31A;
	Sun, 22 Nov 2026 21:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FB45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=qBqDzVZ6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eHsedMCn7C50ZvPquEEzIE0KxsSJ1g9WVAkN9oKP78ErnF9bESFAEjxUNYDhCWkSY3xWZFw7+STEKReuBBKAPriHjnBQpCxvzcI19MoLkOFsyLSnVNSmCsuCFu7+5bgXPRM+djCruW2gz5es9jEyDZQph0BIvANXC0ZcOCKjVwYy+6JdKyyqMlVmRVnDpkdbbmIcqIbfWmMmTW7SyQH0JHv2nuzoK4chntljN8AsXUZTFahnsmqLJsQS5xk4v4lxlCwfMF/WA51g+QQgNqMeMp4ryLT+0JK2IVwgL+KgfsRU+FAqv2xREMuJ4j3VSoPDrlLOkqRBVYRcjoAPePvU9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uI6N0yy3nE3r3l3B3HOfIN6e/2icGcmSb0OOdqzMBF8=;
 b=CMmyqIMRuTxuZMRMH8HgGLtk5WJ3sXq/MaoQi8WOar6ewkWsSBMS/E7W/PpT/fLK7khb1aUhXX0ShnhMZRZ/yZJW5hIFHP4307GrSpj8VjtHpv9rZ6Uq+kq5zk9p6vg32XWUT1NP6n9ObmP+z/VLsb6X+WOUdprYoG7lcn9P+tW8c5qHsxDU8MDjf79anTX5E7pKMo/2BsagBvebodGyzUFJEGVm9jsBSx1NKOxEqakrhA+ooI/a0P6sTC9uQ+HVZKvygbd9RT7BLVoI2XeNDP7mAia2z2uqlm6coFX3RzIXDfYZqKV4GkMAEUI4yn8zA2nEc1pZoqvrRi62++HgmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uI6N0yy3nE3r3l3B3HOfIN6e/2icGcmSb0OOdqzMBF8=;
 b=qBqDzVZ6/a8ws8nTEw5FDFuFazPpP4qYEnSp0GO+eqlHBFB27AvNXA6HvlUkKPoP690dLNi/eBfeKY47mincDIxO+Sx0Ua5+M0kE7tma4Gpm/2kqxh/dP53yRsVBDTOfpqv8/3w7x/bRv160CJmH8CGdnQFy1Npu+YBV2mLpWvmeHiGVqYBYWGucBc5tcjhJpD4yPJjsCCBQTz1mhIZsGQjs+6R0I0wGI0McS9Q09GTnjg6w+j4MJfwXVP4ZkxlcZua7jiahjs9NYeoJ54c4hciEO8enztxr/HW20hY8PgYx7vnqzi/L6UmYo9S/NdGrhypIVMkqgvH2Ty7sdrZlXg==
Received: from MN2PR02MB6863.namprd02.prod.outlook.com (2603:10b6:208:1d7::20)
 by CH0PR02MB7945.namprd02.prod.outlook.com (2603:10b6:610:102::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sun, 22 Nov
 2026 21:38:29 +0000
Received: from MN2PR02MB6863.namprd02.prod.outlook.com
 ([fe80::da67:fd0f:d96d:ac53]) by MN2PR02MB6863.namprd02.prod.outlook.com
 ([fe80::da67:fd0f:d96d:ac53%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 21:38:29 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
	<oleksandr_tyshchenko@epam.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)"
	<ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowangio@gmail.com>, =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko
 Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Jan Kara <jack@suse.com>, Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	=?utf-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, Joel Stanley
	<joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, Ryan Chen
	<ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, Bjorn
 Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>, Jens Wiklander <jenswi@kernel.org>, Sumit
 Garg <sumit.garg@kernel.org>, Scott Branden <scott.branden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Richard Cochran <richardcochran@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "selinux@vger.kernel.org"
	<selinux@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-aspeed@lists.ozlabs.org"
	<linux-aspeed@lists.ozlabs.org>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "op-tee@lists.trustedfirmware.org"
	<op-tee@lists.trustedfirmware.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH 03/14] mshv_vtl: convert mmap hooks to mmap_prepare
Thread-Topic: [PATCH 03/14] mshv_vtl: convert mmap hooks to mmap_prepare
Thread-Index: AQJWRfE/+SnpOcttkojsctxhrcm2aAGmAms6tjvViOA=
Date: Sun, 22 Nov 2026 21:38:28 +0000
Message-ID:
 <MN2PR02MB6863B08CA2829AD44A1518C5D4462@MN2PR02MB6863.namprd02.prod.outlook.com>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <20261105-late-2026-mmap_prepare-v1-3-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-3-c56aadfbab8a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6863:EE_|CH0PR02MB7945:EE_
x-ms-office365-filtering-correlation-id: d8b2336d-6caa-47a5-85d9-08df48e0f280
x-microsoft-antispam:
 BCL:0;ARA:14566002|37011999003|31061999003|41001999006|8060799015|8062599012|19110799012|15080799012|4140399003|13091999003|55001999006|24021099003|25010399006|3412199025|440099028|102099032|52005399003|40105399003|41105399003;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z2t4T2Vac0NjdThNc0dYc21lZ1h3bXA0M0s0ek42QUx3QWNTUm95WHFmdERV?=
 =?utf-8?B?bFp0dnVwYzRXWStzOFhpZko2aHduVFFPUUdycmNIQmFMaVZVWkt5MHlYQitK?=
 =?utf-8?B?MS9CVGh2NFFzdUpzc3R1bVFzU0J3bTlyUytkdGd4c2ozcVNPNUxuY1RoY2Nu?=
 =?utf-8?B?S0F0TzloYktKNmoraEhrUnFoUnpzWE8vT1RlRGdSdTRjNkNuZkkvbUlFOFNX?=
 =?utf-8?B?S3dpblR4NTErTGxwbi9yMVpTT3RpbHBUdHVibk10R3hDTGhuRVRxU2U5a08x?=
 =?utf-8?B?R0czUjlsUDhzNkVpNmk5bGFvbUx4OElHS1RFRDE0ZUpnODdEbEs2NFdGZGtv?=
 =?utf-8?B?SU1nR3RRcUZuREllZFdoTDU4MkJlTVdrZWVBU09tOWlzcVlqUnlkcnRvUCtB?=
 =?utf-8?B?MVh2QzgxQUpYV3VWTnhUY0xGTDIxZExxbGZtemFaeU5BWGsrVExYdDJ1aWFV?=
 =?utf-8?B?dCtnRTBrUnlhaXhxK3JyY0tlUmVDUXNpMlErWWpNTXlsYXA3VFdDTzBNem5E?=
 =?utf-8?B?QlVYSUZyV1labW44YkhGbzc4QnBLbTMvSG9uZzVKTDNwa0RLM0FnV1I4WFU5?=
 =?utf-8?B?eTNFZU8zUldjQ3NxOEVRbHRoVmtlWEVEZXptK1hTZk5yM3ZRYW9hdWhMdStU?=
 =?utf-8?B?Nzhld0NReWxoQzN2Y0dDS3NqUXBsV0Z6Y3p6THl4eTBEYnBIMTUwZ2VYQlBx?=
 =?utf-8?B?elNXN3U3YlJiNnRLcU9FVFVaQml5RXFpVzhzOTZtL1M2Z2NZbDRyUVNrK01z?=
 =?utf-8?B?K0w4REIwSzlWRlNiTGV2bnlYeldySFVRWUtUYjJqeXpxNUlmNTlDTHhGbUNz?=
 =?utf-8?B?OG1qT25tdmZQQVpjQTBZNnhsbWNOdVAvaUN2YUpweGJVWDNxenpkeVpjK1Ux?=
 =?utf-8?B?bk5aK3U3SDBNOHJHZ21EZWJhNGZrSTBBSW96TFJqVk5BT3VhZ2xtZzRCclBs?=
 =?utf-8?B?cnJLL1E1Vmg4Vm56eVBtNFNjVFVTU3E5ZjVaVHF5WjZKT0Nhdi95RDMycEtm?=
 =?utf-8?B?a2tVSCtjVnJURUVRU3Q5K2lOdWdpOEJydFFWYzlvcjJwOGFlVnBsbXNyb2hW?=
 =?utf-8?B?REFWMVBlM3UzNG5WMWQyd2M2N2YwUEtMeHlIQ0YvV2VxRFdHY3RDazluR3Jz?=
 =?utf-8?B?b08wNWtzRVBvOUd2d0NpUjBnTGk5ZmdKY0drOWRSTnBRSURaQnlETHA2VFho?=
 =?utf-8?B?WlNDdGIyNllNd0dZV1hxQWJhUSt6aEdtVElVYk1oYUJMSit6Tmp3YWE3Q01j?=
 =?utf-8?B?Vm4wdnArcUFsbTlpMDFoNnFRY0xuUHBNejZoSTF2RndNdnZpdEtSQm92VDRK?=
 =?utf-8?B?dGJCNVN4bldXclRabTB3NWtTcDFWQStHd3BJcmlzRlNsYWJWM2FhMDBPWFV0?=
 =?utf-8?B?a3BsS20yZ3dWbjVKSm1Odm5lU283VFNVd1VFZHJTSWNsYTZ1NG1GN2NnMW53?=
 =?utf-8?B?OC9tZFhhd05WbjE5QUN4TGxlbnlaTWNVN1lhVkdRNys2cGZWeHFXTlQxbnV2?=
 =?utf-8?Q?4bODTQ=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a3Jkbnpkb08wQ25uRXFYRmVCdVh4NU9ob0Q2VDZ6L2M0bWtBNTN5ZlR4cGkv?=
 =?utf-8?B?T3JsYUdkbnFEUjFvNzAyZkt2ZkRULy9Ra3pXakQvcDU3Tm4vL0hETWtUUFY3?=
 =?utf-8?B?T0Y4TzBSMFpoa0ZPaWFlMWc4Qi8wckFjT3piRGRHUDdaM2Q2NEtZY3JZYW1E?=
 =?utf-8?B?aGIvQzFqNHZ4NitLWjdqOFFKTFR1dWYxZjNtSkluU3hUR1ByM212MEVGMUtV?=
 =?utf-8?B?QkRnVzl1YmcvdzZSQnZJeGFoWHIwVUxwelhnZTZIQVlvZ1RpdXpCclFLUkgw?=
 =?utf-8?B?OUJxUitVR1crUVlmbkJOV1h6WVhhMitUYzBZa2lORWdRaDNmV2VORW8xTUI3?=
 =?utf-8?B?VlZscnZ5bWpwbU9rWEs4dSs0TzI5V1E0SVJsaXAxQStiK0t1blJ5VmJmRFJi?=
 =?utf-8?B?U3ppM0VWSlJQbGErSHRmVmhMaEdodDFkM0w3TklLczhsWHFSVTFFdDNncEVp?=
 =?utf-8?B?UGhWRnczTytBSHQ0WXBjR2xhTTYvcG1KRnBSOHYrMkdkV1BxMzBGc1IyRCtM?=
 =?utf-8?B?S2FZUmZHTytDQUttdUdtd3M5L2F6dWZXWEZ1eDJGL2VQQW96TXU0UHh2OWJv?=
 =?utf-8?B?Wm9BWEJST3FSYkN5VlU2dTJXWjZMTUwxdGo5TDljMnF3aVd2RVQ1ZitCdS82?=
 =?utf-8?B?OGNkSzJmWnpvbS9BQldkTjM1aklZK0dZdWNLdEdPQjBoRGVvU3RLSDlUU3A2?=
 =?utf-8?B?dWVuMXpHOFVnU3V6SmlIWnF2ZjJNWXRwaTBIcEQ2dmtKclVDVkNIUEJLRWs0?=
 =?utf-8?B?ZTF4aWc4azdtYXZIdUlDblVtUXZsTTdrZTgwVG80SzhTWUc0SThMbFc2bWNW?=
 =?utf-8?B?VDZwODhaeU9oODFJakJCNXVmSC9RZWdWMTYvV3pwWHZtNDFwYzBoQ3FKMG95?=
 =?utf-8?B?Rzc2SG9KeGszTWMzbUZuUUdnbjIrSWxuV3lvUjQ2YWt2TEpHSzB6TDh2N0tm?=
 =?utf-8?B?OFVKcEUzS3RNU0Vpb2NkOFFUcHRMajdkQ1R0SGNHY3dyQkdMU1UyeEZEc1h5?=
 =?utf-8?B?UENHU0lZU0g1WXFpckRBUG56SmdjajIxWUZ5Zi9tY0xuak5Xc1BsSWhIdHVp?=
 =?utf-8?B?NXREN1htNWRBYlBSS1NJUHJtS1U1d0JuTmpzZFZZQnVYajIwYXhRMW4rOEJ6?=
 =?utf-8?B?ZDRVQVhSYms0bGZWWWowUWc4NlU2RnlHYWh6R29aaWdkekd5UTFTQkNFK3JE?=
 =?utf-8?B?MkgyT3R0dFo1SWJIcnlXRmE0clpJbFZmQ1ArWFljTTNZRVp4MjIyNmozbEdk?=
 =?utf-8?B?dS9HLzZUc2R5R3Jpd252VUdlcGJqUGIwR2tOWDFSZDBmYW5HUkRHK0xYQ3Vq?=
 =?utf-8?B?dmJTaWJWV3R6dlRVK0pOL1NOanJVSUxCSU4veVBWb0luSmRKdHZUU0Noczg5?=
 =?utf-8?B?L0hHTWEyYUNCczVla1hTMUNuN2MvQi9MdmptS2pna0ltZ2NmUU11TVVJRnln?=
 =?utf-8?B?UFRYWmtTQU1uc09nQ3E3RjNOT24ybEp6SDgxUnh0UGRxS1J4V25YTWdmdmkr?=
 =?utf-8?B?bjVVK0ZjbW5FV0h5cm02OUlwZlJzT3hDQWtVT2dSc0VGTHpoNHp5OEo4YVpJ?=
 =?utf-8?B?Qm5qc014K3J3elRGbVo0VHFmVEQ5T3JUNW10STc0aHZWelFaOGV4QzJwNk9B?=
 =?utf-8?B?UWRNWkxzclh2cW1ZcHN0MC9uZWxVTFVLTXdFb3Y5eHRDdFlRVml6RTF0VjFn?=
 =?utf-8?B?emNpa1BFZm1sOVF3WGswTlpJUUhtdUFCT25XVVJqbnlKTGhQTE14VXNzMDNn?=
 =?utf-8?B?R3pBTFcvbXVMaGlFSmNYS3FOMEF6bERtdHpYUjJvQ0gwQWxJREtSOVpvZTRT?=
 =?utf-8?Q?uT9cCdOV8g+FDsxLKA/qcigNmJzvkoF5SRKro=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6863.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b2336d-6caa-47a5-85d9-08df48e0f280
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2026 21:38:28.8213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7945

RnJvbTogTG9yZW56byBTdG9ha2VzIChBUk0pIDxsanNAa2VybmVsLm9yZz4gU2VudDogVGh1cnNk
YXksIE5vdmVtYmVyIDUsIDIwMjYgMTowNiBQTQ0KPiANCj4gTW92ZSBmcm9tIHRoZSBkZXByZWNh
dGVkIG1tYXAgaG9vayB0byB0aGUgbmV3IG1tYXBfcHJlcGFyZSBob29rIGZvciBib3RoDQo+IHRo
ZSBtc2h2X3Z0bCBhbmQgbXNodl92dGxfbG93IGRldmljZXMuIFRoZXNlIG9ubHkgc2V0IFZNQSBv
cGVyYXRpb25zIGFuZA0KPiBmbGFncy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IExvcmVuem8gU3Rv
YWtlcyAoQVJNKSA8bGpzQGtlcm5lbC5vcmc+DQoNClJldmlld2VkLWJ5OiBNaWNoYWVsIEtlbGxl
eSA8bWhrbGludXhAb3V0bG9vay5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL2h2L21zaHZfdnRs
X21haW4uYyB8IDE0ICsrKysrKystLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHYvbXNo
dl92dGxfbWFpbi5jIGIvZHJpdmVycy9odi9tc2h2X3Z0bF9tYWluLmMNCj4gaW5kZXggZDgyMjUy
NDJjNzNmLi5lMzcyZDRjMDE4OGQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaHYvbXNodl92dGxf
bWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvaHYvbXNodl92dGxfbWFpbi5jDQo+IEBAIC04MzIsOSAr
ODMyLDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2bV9vcGVyYXRpb25zX3N0cnVjdCBtc2h2X3Z0
bF92bV9vcHMgPSB7DQo+ICAJLmZhdWx0ID0gbXNodl92dGxfZmF1bHQsDQo+ICB9Ow0KPiANCj4g
LXN0YXRpYyBpbnQgbXNodl92dGxfbW1hcChzdHJ1Y3QgZmlsZSAqZmlscCwgc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWEpDQo+ICtzdGF0aWMgaW50IG1zaHZfdnRsX21tYXBfcHJlcGFyZShzdHJ1
Y3Qgdm1fYXJlYV9kZXNjICpkZXNjKQ0KPiAgew0KPiAtCXZtYS0+dm1fb3BzID0gJm1zaHZfdnRs
X3ZtX29wczsNCj4gKwlkZXNjLT52bV9vcHMgPSAmbXNodl92dGxfdm1fb3BzOw0KPiANCj4gIAly
ZXR1cm4gMDsNCj4gIH0NCj4gQEAgLTg1Miw3ICs4NTIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGZpbGVfb3BlcmF0aW9ucyBtc2h2X3Z0bF9mb3BzID0gew0KPiAgCS5vd25lciA9IFRISVNfTU9E
VUxFLA0KPiAgCS51bmxvY2tlZF9pb2N0bCA9IG1zaHZfdnRsX2lvY3RsLA0KPiAgCS5yZWxlYXNl
ID0gbXNodl92dGxfcmVsZWFzZSwNCj4gLQkubW1hcCA9IG1zaHZfdnRsX21tYXAsDQo+ICsJLm1t
YXBfcHJlcGFyZSA9IG1zaHZfdnRsX21tYXBfcHJlcGFyZSwNCj4gIH07DQo+IA0KPiAgc3RhdGlj
IHZvaWQgbXNodl92dGxfc3luaWNfbWFza192bWJ1c19zaW50KHZvaWQgKmluZm8pDQo+IEBAIC0x
MjgzLDEwICsxMjgzLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgdm1fb3BlcmF0aW9uc19zdHJ1
Y3QgbXNodl92dGxfbG93X3ZtX29wcyA9IHsNCj4gIAkuaHVnZV9mYXVsdCA9IG1zaHZfdnRsX2xv
d19odWdlX2ZhdWx0LA0KPiAgfTsNCj4gDQo+IC1zdGF0aWMgaW50IG1zaHZfdnRsX2xvd19tbWFw
KHN0cnVjdCBmaWxlICpmaWxwLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4gK3N0YXRp
YyBpbnQgbXNodl92dGxfbG93X21tYXBfcHJlcGFyZShzdHJ1Y3Qgdm1fYXJlYV9kZXNjICpkZXNj
KQ0KPiAgew0KPiAtCXZtYS0+dm1fb3BzID0gJm1zaHZfdnRsX2xvd192bV9vcHM7DQo+IC0Jdm1f
ZmxhZ3Nfc2V0KHZtYSwgVk1fSFVHRVBBR0UgfCBWTV9NSVhFRE1BUCk7DQo+ICsJZGVzYy0+dm1f
b3BzID0gJm1zaHZfdnRsX2xvd192bV9vcHM7DQo+ICsJdm1hX2Rlc2Nfc2V0X2ZsYWdzKGRlc2Ms
IFZNQV9IVUdFUEFHRV9CSVQsIFZNQV9NSVhFRE1BUF9CSVQpOw0KPiANCj4gIAlyZXR1cm4gMDsN
Cj4gIH0NCj4gQEAgLTEyOTQsNyArMTI5NCw3IEBAIHN0YXRpYyBpbnQgbXNodl92dGxfbG93X21t
YXAoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0KPiAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbXNodl92dGxfbG93X2ZpbGVfb3BzID0g
ew0KPiAgCS5vd25lcgkJPSBUSElTX01PRFVMRSwNCj4gIAkub3BlbgkJPSBtc2h2X3Z0bF9sb3df
b3BlbiwNCj4gLQkubW1hcAkJPSBtc2h2X3Z0bF9sb3dfbW1hcCwNCj4gKwkubW1hcF9wcmVwYXJl
CT0gbXNodl92dGxfbG93X21tYXBfcHJlcGFyZSwNCj4gIH07DQo+IA0KPiAgc3RhdGljIHN0cnVj
dCBtaXNjZGV2aWNlIG1zaHZfdnRsX2xvdyA9IHsNCj4gDQo+IC0tDQo+IDIuNTYuMA0KPiANCg0K
