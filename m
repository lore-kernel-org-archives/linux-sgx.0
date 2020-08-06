Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB96C433E0
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6215E2311A
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aXVZSySx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgHFRQR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:16:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730310AbgHFRQF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 13:16:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076D3U7g110854;
        Thu, 6 Aug 2020 13:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=QJht0r9+pb7DHhPqjRhH2JvzfLPN8ybMHKn/qOjbH2k=;
 b=aXVZSySx0VdbMCIc7UwoUYNkbRxEfw1H1fWM2hUYhG6l49upkohTYMQ8YIyiBYMuUGvk
 3E0yaL7/gopg4Lxd2DYLqiRR2zXIJmcSn0JGX9nxff4a099qKGNmgLibIntdgZLVXmXd
 C36coJ1tIe5A9Q3jlcjTPb4T+i331Nw8XyY2YWauKZs1fsNbAUg1972qrp9HSsdsGUFm
 EbNrgecK4O9M5mm2D0FuKP8xY2OsAjTC0AL/cfr3lxTF+cRxsph1HgaZrKePG05EGKN1
 bi+OxnIhvtdB/HTi/V7yJ98WwQ8MA9fWW2x9W8OH/QO+A7Yu2PZ+Zq54bYHkdunBe6kI 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32r6gwttmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:16:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Cx7fl151578;
        Thu, 6 Aug 2020 13:14:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32qy8nbxcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:14:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076DECB8015724;
        Thu, 6 Aug 2020 13:14:12 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:14:12 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id 17C8AF04845; Thu,  6 Aug 2020 14:14:06 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 02/24] x86/cpufeatures: x86/msr: Add Intel SGX
 Launch Control hardware bits
In-Reply-To: <20200716135303.276442-3-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-3-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:14:06 +0100
Message-ID: <m2d043syqp.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:41 +03, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> Launch Control.
>
> Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> called enclaves, are always signed. All enclaves signed with the public key
> are unconditionally allowed to initialize. [1]
>
> Add FEAT_CTL_SGX_LC_ENABLED, which informs whether the aformentioned MSRs
> are writable or not. If the bit is off, the public key MSRs are read-only
> for the OS.
>
> If the MSRs are read-only, the platform must provide a launch enclave (LE).
> LE can create cryptographic tokens for other enclaves that they can pass
> together with their signature to the ENCLS(EINIT) opcode, which is used
> to initialize enclaves.
>
> Linux is unlikely to support the locked configuration because it takes away
> the control of the launch decisions from the kernel.
>
> [1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration
>
> Reviewed-by: Borislav Petkov <bp@alien8.de>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/msr-index.h   | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 545ac3e0e269..0a4541e4f076 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -352,6 +352,7 @@
>  #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
>  #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
>  #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
> +#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */
>  
>  /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
>  #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 18e08da19f16..3d7c89a8533f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -582,6 +582,7 @@
>  #define FEAT_CTL_LOCKED				BIT(0)
>  #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
>  #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
> +#define FEAT_CTL_SGX_LC_ENABLED			BIT(17)
>  #define FEAT_CTL_SGX_ENABLED			BIT(18)
>  #define FEAT_CTL_LMCE_ENABLED			BIT(20)
>  
> @@ -602,6 +603,12 @@
>  #define MSR_IA32_UCODE_WRITE		0x00000079
>  #define MSR_IA32_UCODE_REV		0x0000008b
>  
> +/* Intel SGX Launch Enclave Public Key Hash MSRs */
> +#define MSR_IA32_SGXLEPUBKEYHASH0	0x0000008C
> +#define MSR_IA32_SGXLEPUBKEYHASH1	0x0000008D
> +#define MSR_IA32_SGXLEPUBKEYHASH2	0x0000008E
> +#define MSR_IA32_SGXLEPUBKEYHASH3	0x0000008F
> +
>  #define MSR_IA32_SMM_MONITOR_CTL	0x0000009b
>  #define MSR_IA32_SMBASE			0x0000009e
>  
> -- 
> 2.25.1
