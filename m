Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012019.outbound.protection.outlook.com [52.101.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC04317707;
	Mon,  1 Sep 2025 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756732963; cv=fail; b=ZCtdgQgx3YfxsQBJ6Dsl0n6kyw1XS1zQ2jFn21Di/lO4d7WkpEIdQdKBRAPe6tLJddepBthEcXMdxkjQZkb5Cs/X5O0Sa2nyake+MSw6dsix8ltsE2lL8f/v3jZjrhipwIbZYp3RQjEigiYL2K+ynAaC+/16gMob57MVhEJpFWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756732963; c=relaxed/simple;
	bh=Iy6xNDcZfvOlxeKwSmtuRDRBPmB+lkrr01TY/JMvla4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ldnQBYmb/ul6m4bnY1XcGkoTzWwvB8Vb9H3K4hJf0uReFhgc7ANjG1GTC6N5C9F2BlNkXVLQn5uQsOr98JF7Gk45rwzCbvXpTm01Esd6uSdkHeccMTfZ1A4yJpD8SQzr8smCe8gtYxU9sR/+vJSIUJLR/qGGzIlrxgExUaYx2nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=OvUAHyrS; arc=fail smtp.client-ip=52.101.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="OvUAHyrS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCd+bAoYT2FJfyj0ZGoXkzzisnH40Vq3Qf7/YKv0gxTRBAeaqxRI3Fh4HHEJSCoCOU86Hh+LapDxJ+DbVHbJfPATwEWPloZVRmzMHEZdAiPcts295P2iaNTPfqqwh8dThz5tMDZMdnrjH60/IZJSHY7Wx9YteUyfpx4vWPU71SduZrEfGlTPAQOOe0rSOd167Vvt6GBg4+fklwjoEEpRZkiB9OfohYY+HuwLfgMNj1W4TYy+1bKywXY0AykxpBZMizoHtCjEVivthqn5wP042VJCw5cD6YjWHgG84M3mQMLdhoDxJwx0TT6GaHDcRbNcBL+pqZi01XxZkNDlqW2D8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+GviwW1YW7TlPN5KB9NAtKjnIioCCahKUQsNnJK084=;
 b=dBpZZvr89m7DC81aUo5e7VPjBoEzYkFVkCV/RrhIIL00WdHGtiVTovuk5tML7kNmvsX42W54Xz3XqMJNHDTNlK5Ep34N2cibU5qRcuZ5svBmKrDmUR1dBZXqK7/scaB/x6FdRU8VBRU3pgPWPIIeDM0sDZhcDWNI+tIjz6iZVY0yE9i4nZJXSyY+ZgDYpl0H31HmsY2zhMptJ0nqdtm0MW+47w0TmOLbvFgqCW6nv+I5LaOOmTQ0vT/gZgknLVyiLDSOolZfo0Se1c6prPPgLCmh2tKCjo7dIKNzTIY1fFtH1/NsjlCHrqppQf559lS29mIb72lSNQxWReygUue80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+GviwW1YW7TlPN5KB9NAtKjnIioCCahKUQsNnJK084=;
 b=OvUAHyrS9cOrSh08nxSz2/mNP3GmMMFj5HGiFf2wnocf5kTpNagvDWKDiY17ZTy6lFTv276tKH6UJsk9ueUH/GC8rOzxW9rB7aTN9hy2vrNAgLzENnp0yxO+wz/VsBkKp2Jpwvza3gttFJEvmQXHSnznmh+gBtSxJuhItkhq4AXnAdVVa/IfbvktizIPJa77I/1DkJltsZfsy9rW2A2LEz9FxzErEq+8FR88cxdjws6znd+VuJ3RHqKz/AhBWifhw/QljylVFqqZUP5AcSksZ8HspPmOclspaqvvmk0C/MuYiTEL63uhGhdMbWEnDX1tK7uF5vGqjy6YBlGl1wOkyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by PUZPR06MB5698.apcprd06.prod.outlook.com (2603:1096:301:f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 13:22:39 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 13:22:39 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org (open list:INTEL SGX),
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] x86/sgx: Use guard() instead of mutex_lock() to simplify code
Date: Mon,  1 Sep 2025 21:22:28 +0800
Message-Id: <20250901132229.650658-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0231.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::9) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|PUZPR06MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d527519-7018-463b-4901-08dde95a9f6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zJHhDJL/AVgSB+RVRvDFa9gKyCot4DeZ7MWvEq9O7A0npk0RfBNUINITDEcD?=
 =?us-ascii?Q?/+aSBLx4m4DpJbwc0d9cOI1PS+Lp4APFbMo0U8R3+2gTD3XcgOsI/2ybBGRi?=
 =?us-ascii?Q?6IMfajKwNCH7Dkl4bgvEHGdQsC9mXHdyx2xf8UbiDrk8VXb0EGmMwSxT+x2H?=
 =?us-ascii?Q?piiGaVtqFyZyF/6ullG6cuhMrpyolSHs+Tybo+TmC7Bx53J69TJtEVzJ7mbR?=
 =?us-ascii?Q?b+47Xo0+O3PF4RSeRJpNY1AZwhS43XGxjDvKB+uszXDkh7IJ8X/fwH/GRsmT?=
 =?us-ascii?Q?7GhlNlbr13uBFcw1c/geaNigQ6h4jzlV7MWhaHfBNKXZsLk//OvxJF/WXGn6?=
 =?us-ascii?Q?PhGwLxbqEWvC6dUbOA3LJXNIwEwVO2fia8Kk/58wZQeFcSUJbFowBs6XtJO8?=
 =?us-ascii?Q?kii5gO116B+NWi9N0JRDE79j1VnPDEgLbsEw4FFw3WByHN9CUZnzuBhdjd4z?=
 =?us-ascii?Q?69coCqFH4jatJ6PHiNpnXJiAhq6/pACx0NVYK9yHfv7eQGq/JtNGkX8T3pR2?=
 =?us-ascii?Q?IR1A0jQ1tVvDufBPjbyrlhxXdp2eXIZQmY29XGyjF1nLVawSqaAffWQAo8Vp?=
 =?us-ascii?Q?XMd9RzECfpyUb6mcd0ne/pZWamqydG7tydvFMgVm/kHxmVI1QshrXqd/Za5a?=
 =?us-ascii?Q?NrNoFWohnV8xwm6Ks8WX9h8Plexa+/pdKR0pd91kK568XZXJDTWWec7QmG7L?=
 =?us-ascii?Q?9KbzYBjkE9BtnSQ0dCpq9Bjb/jz0hXj2wv22PAmI0htHl7fMcBV1Ku7neNsW?=
 =?us-ascii?Q?YGeEO0q+ZTwUiMa8meTCuqLBiiVL1wFgMbUCoJTRyj6fUGJ8y1tNQWx7JHmR?=
 =?us-ascii?Q?cwUZFGQjj9uqdTUEg08hxBmGb6nLBidNllnM2UZOyXEpCtOxicuqFvJ1/Jf1?=
 =?us-ascii?Q?HC7hHGLhTmyzbAuwxDLsoYokPOV4GSHYAuNkO+Oi3BqVQGkRmXiXofIr4Dzn?=
 =?us-ascii?Q?2yQ79E+jkh38GubsS5G2urPEnTnIfBWXHykLB0QwdndYExfQY10FtYQj0Duy?=
 =?us-ascii?Q?maQrtWAlqPzqitJiU40an/PrTyfg/e5CyshnZKB7s+Yq6srbcUzZp/LQFMAt?=
 =?us-ascii?Q?1fuYJ2GvksHMFP3chTbQWfOy9DhCwQROr1cCxJcmzfw19z0MOmkoeMQ45270?=
 =?us-ascii?Q?9ybtP9lD4ygwkfhKoEI8UNKmY2juKpUrjMBZwrIDt+bwSDQWecq3CffU1Tl8?=
 =?us-ascii?Q?53lj15ucGDzts7ouqCVtYWm+3QOQU3ptxVvaM4yOvaSaCse3kYSJVEhaYx+N?=
 =?us-ascii?Q?1xns3XHKEu2IWPS4o1xpXEQowLcmB2rtT0/L3DilomSfF2yog5Dt0WawfoJp?=
 =?us-ascii?Q?6mes+phHx45m93CfwRusdXhnsPoZ2PJZjDB+9pjqyrxqc8AK2AKiXuRS7L2l?=
 =?us-ascii?Q?fPh44SpuJ9iekU5JXneg+JXwnz8jm2l/wOmQNI1UE877ThXKXm+lWlTyOLGk?=
 =?us-ascii?Q?+V64mJHlW4wBgMGkt+S0sj6JbwmcAechCkcZGg8gY7IKGVacJP32zg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3JMGkV8FechBDy7E+MuZLWWCR1LvjiqmswgbFIB9UP+a4CmAXLNHqT2tqg5f?=
 =?us-ascii?Q?IkZt8DrninbvWvgcADBBElifSH75HEDEuB5Vov8t51yGtbi5SggT2gyCxete?=
 =?us-ascii?Q?/vvyx9I8uJUYa9CyrT6/g3KhSu7thw7GY49AzMIuxXDxuei4IY5839esw6xS?=
 =?us-ascii?Q?1T/Ab22+vSzM+Ulo4lItNAGgp/PatOAt/OYKPkDHjanLr7XFcX/raTKov4aI?=
 =?us-ascii?Q?DhuQrLV3OC4jlPxRvl1ErpojX/lA4RuaxcTnZ0ihJVOI8go0fZ5JLfjbH4mj?=
 =?us-ascii?Q?rakcjH3dveNjStAFciJq7q+E69nWcLn/ixO8TywzByBI8C+454eW75kGXQiI?=
 =?us-ascii?Q?OlXoN/dHs4+BcFoDk+u+sdO5a5wmx8dgdOT3IdTWygKBkFa9NQb8MfeE/t8f?=
 =?us-ascii?Q?H6SsHWboW5PjzcpfVJDtB6V/3sYF4w4F2NV2KJEqWnjdKM8jROn/8PU5sWXa?=
 =?us-ascii?Q?iio89h4RYNHHtOmMkNkS8qm5NtSs7FFNW0G1a2QDhyZR72YoUTuo3DUddTEB?=
 =?us-ascii?Q?HVSoPNPh5giB9xdTlFI99JdzO76s33tRTtktAEZy8ln54AjZ/ydA3KvfY2/8?=
 =?us-ascii?Q?nnMrdeDC5LphLmjDBf+Y0L+BX3r/jOZTxU/bAbLAduXt9BhFstOjJBgk+nB1?=
 =?us-ascii?Q?NE1UF7vivi9kgkJQPI4simfkMNsw5rNFs+w/BxyQIU3YJnSAFBmyc6IYOKOm?=
 =?us-ascii?Q?xpxzgNZ7iNoez8HKqB06wB2/Ao8PH05uoRXWQfrSs0r3XJFot/VpzqayGCC0?=
 =?us-ascii?Q?xaUQGxWkxPao2IpSt3QaVED6gD1SrUwlXR7apmAMgJih4EGZkLZV7IQ8jaZn?=
 =?us-ascii?Q?JUrrf7+sQjd1YxLHXWg/3DbhM7H8TUCQhj8KwxNJFM3/T1oHqqybs8/QEGtz?=
 =?us-ascii?Q?nz1tGcdlU5O9EWSEIEt0jeoionOJG9z5hZaRP2dMEdPrHzBdzmB3xsuPEPCo?=
 =?us-ascii?Q?S8t8L8v2V7dv3mZ2LvBVYGzULme8Baat/bq6U1xXmbdhjaF5CIleDABewD4q?=
 =?us-ascii?Q?NSQ0PDbQ3Jda2ljJuq0+8rGOTCnieu1rfwH0lQw/fmuC3XXbBvrIK2+Fp188?=
 =?us-ascii?Q?HczEUeq958f4lGyQxLHeMXHIE5HKkOBVs7gWoRTwr73r85pDBrJIZZiXfCUr?=
 =?us-ascii?Q?C+yWTi0h+0F8IkpnL282vvR4Cd3tUmCJOXYVRz1n+RBjwhG+YF2lU+O0a4fS?=
 =?us-ascii?Q?eh6bMG/HRNol+/LNGYyRaLY2xvLG69HQxMVF+NU5djdMBIrMH7nVav5Yuvfm?=
 =?us-ascii?Q?9940yf80+quWw7lLSenjU7noeNI+X9Jfjv3pNf1GOU960A5n+e6H35pR7yFb?=
 =?us-ascii?Q?GWPUPvVcCgZgix3G4v5Jxc/jgN0pOSJUrQm6KjMcudmsgozTc9fh8zTi9dJ6?=
 =?us-ascii?Q?KXpiN0vFE/GkybKiGvwhdsjQjm5YLcHfk7tEKxftxO22DD9AXZIQjIjwaiPM?=
 =?us-ascii?Q?BENxFEuNIeCv6L3bq4338FrHtR6Qh7er/JlgVYKTQIpbDhah5qkrMM5IAcuK?=
 =?us-ascii?Q?qwcNCsRDtRkmHZQqJO3CisQ2JYai+VoPBesSC26lvhJLhVEIYquqZna1YZ+F?=
 =?us-ascii?Q?EF8LKpNB6wQBmLzE8VtRzW5aHBj1pYouNjUWmq1f?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d527519-7018-463b-4901-08dde95a9f6c
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 13:22:38.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIWXz4/fcb6tKaOmYoT3XAo10nZdSHgNqBZ+8qVm171WzAOWTlWka4cWpYwl8ORqqZxQifkrbi7qQwgKctb+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5698

Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
error handling to just return in case of error. No need for the 'err_out'
label anymore so remove it.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 66f1efa16fbb..b61faa1aed7f 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -501,7 +501,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	sha256(sigstruct->modulus, SGX_MODULUS_SIZE, (u8 *)mrsigner);
 
-	mutex_lock(&encl->lock);
+	guard(mutex)(&encl->lock);
 
 	/*
 	 * ENCLS[EINIT] is interruptible because it has such a high latency,
@@ -534,7 +534,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
-			goto err_out;
+			return ret;
 		}
 	}
 
@@ -550,8 +550,6 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 		set_bit(SGX_ENCL_INITIALIZED, &encl->flags);
 	}
 
-err_out:
-	mutex_unlock(&encl->lock);
 	return ret;
 }
 
-- 
2.34.1

