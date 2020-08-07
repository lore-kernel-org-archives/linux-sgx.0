Return-Path: <SRS0=bmuu=BR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CADC433E1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Aug 2020 09:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338CB206B5
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Aug 2020 09:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dcWLatPk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHGJiQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Aug 2020 05:38:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgHGJiP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Aug 2020 05:38:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0779XXok141490;
        Fri, 7 Aug 2020 09:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1FoffpoXhzA3a4zrPZ4VMUuiSaZwDHQIKs4oQQdNli0=;
 b=dcWLatPkqM8onWPOXunZcpFp8VPPT5bPblyIm8+u3dHItghRyYoHWPUooIWB+vJf3T38
 AkZieRiAVOMYdwsM+H9kXTG7+hzW3+G/Bm78Fb6MpOnYMG2FIRxb9ATNuiXrfhQ3hbxM
 epT6aTCeumQjuOEaFRGD4SE1KosNUXpfQpq3Knc0qP+D4CbNuwQDf9XR42KCBjvirSRQ
 lMz/QqS8F6qXMHaUsoaDKpxeLsHFxvD2MXs3WUtPkpnVN6ajI/pT/mzQwmOGA8fChBU5
 ZKgu/XD0iKhY29mDWE7DM64nKgPYzNVuLmaIe6r5N15EKS4uvRIVLywCasavUw0tCZff DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32r6gwykmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 07 Aug 2020 09:37:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0779X2K4079385;
        Fri, 7 Aug 2020 09:37:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32pdp043yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Aug 2020 09:37:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0779bjOf021591;
        Fri, 7 Aug 2020 09:37:45 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Aug 2020 02:37:45 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id 26474F2118D; Fri,  7 Aug 2020 10:37:39 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 05/24] x86/sgx: Add wrappers for ENCLS leaf functions
In-Reply-To: <20200716135303.276442-6-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-6-jarkko.sakkinen@linux.intel.com>
Date:   Fri, 07 Aug 2020 10:37:39 +0100
Message-ID: <m24kpere3g.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070071
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:44 +03, Jarkko Sakkinen wrote:
> ENCLS is a ring 0 instruction, which contains a set of leaf functions for
> managing an enclave. Enclaves are measured and signed software entities,
> which are protected by asserting the outside memory accesses and memory
> encryption.
>
> Add a two-layer macro system along with an encoding scheme to allow
> wrappers to return trap numbers along ENCLS-specific error codes. The
> bottom layer of the macro system splits between the leafs that return an
> error code and those that do not. The second layer generates the correct
> input/output annotations based on the number of operands for each leaf
> function.
>
> ENCLS leaf functions are documented in
>
>   Intel SDM: 36.6 ENCLAVE INSTRUCTIONS AND INTEL=C2=AE

Tested-by: Darren Kenny <darren.kenny@oracle.com>

>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encls.h | 238 ++++++++++++++++++++++++++++++++
>  1 file changed, 238 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
>
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/en=
cls.h
> new file mode 100644
> index 000000000000..f716b4328614
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -0,0 +1,238 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +#ifndef _X86_ENCLS_H
> +#define _X86_ENCLS_H
> +
> +#include <linux/bitops.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/rwsem.h>
> +#include <linux/types.h>
> +#include <asm/asm.h>
> +#include <asm/traps.h>
> +#include "sgx.h"
> +
> +enum sgx_encls_leaf {
> +	ECREATE	=3D 0x00,
> +	EADD	=3D 0x01,
> +	EINIT	=3D 0x02,
> +	EREMOVE	=3D 0x03,
> +	EDGBRD	=3D 0x04,
> +	EDGBWR	=3D 0x05,
> +	EEXTEND	=3D 0x06,
> +	ELDU	=3D 0x08,
> +	EBLOCK	=3D 0x09,
> +	EPA	=3D 0x0A,
> +	EWB	=3D 0x0B,
> +	ETRACK	=3D 0x0C,
> +};
> +
> +/**
> + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> + *
> + * ENCLS has its own (positive value) error codes and also generates
> + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> + * with system error codes as everything percolates back up the stack.
> + * Unfortunately (for us), we need to precisely identify each unique
> + * error code, e.g. the action taken if EWB fails varies based on the
> + * type of fault and on the exact SGX error code, i.e. we can't simply
> + * convert all faults to -EFAULT.
> + *
> + * To make all three error types coexist, we set bit 30 to identify an
> + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> + * between positive (faults and SGX error codes) and negative (system
> + * error codes) values.
> + */
> +#define ENCLS_FAULT_FLAG 0x40000000
> +
> +/* Retrieve the encoded trapnr from the specified return code. */
> +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> +
> +/* Issue a WARN() about an ENCLS leaf. */
> +#define ENCLS_WARN(r, name) {						  \
> +	do {								  \
> +		int _r =3D (r);						  \
> +		WARN_ONCE(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
> +	} while (0);							  \
> +}
> +
> +/**
> + * encls_failed() - Check if an ENCLS leaf function failed
> + * @ret:	the return value of an ENCLS leaf function call
> + *
> + * Check if an ENCLS leaf function failed. This happens when the leaf fu=
nction
> + * causes a fault that is not caused by an EPCM conflict or when the leaf
> + * function returns a non-zero value.
> + */
> +static inline bool encls_failed(int ret)
> +{
> +	int epcm_trapnr;
> +
> +	if (boot_cpu_has(X86_FEATURE_SGX2))
> +		epcm_trapnr =3D X86_TRAP_PF;
> +	else
> +		epcm_trapnr =3D X86_TRAP_GP;
> +
> +	if (ret & ENCLS_FAULT_FLAG)
> +		return ENCLS_TRAPNR(ret) !=3D epcm_trapnr;
> +
> +	return !!ret;
> +}
> +
> +/**
> + * __encls_ret_N - encode an ENCLS leaf that returns an error code in EAX
> + * @rax:	leaf number
> + * @inputs:	asm inputs for the leaf
> + *
> + * Emit assembly for an ENCLS leaf that returns an error code, e.g. EREM=
OVE.
> + * And because SGX isn't complex enough as it is, leafs that return an e=
rror
> + * code also modify flags.
> + *
> + * Return:
> + *	0 on success,
> + *	SGX error code on failure
> + */
> +#define __encls_ret_N(rax, inputs...)				\
> +	({							\
> +	int ret;						\
> +	asm volatile(						\
> +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> +	"2:\n"							\
> +	".section .fixup,\"ax\"\n"				\
> +	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
> +	"   jmp 2b\n"						\
> +	".previous\n"						\
> +	_ASM_EXTABLE_FAULT(1b, 3b)				\
> +	: "=3Da"(ret)						\
> +	: "a"(rax), inputs					\
> +	: "memory", "cc");					\
> +	ret;							\
> +	})
> +
> +#define __encls_ret_1(rax, rcx)		\
> +	({				\
> +	__encls_ret_N(rax, "c"(rcx));	\
> +	})
> +
> +#define __encls_ret_2(rax, rbx, rcx)		\
> +	({					\
> +	__encls_ret_N(rax, "b"(rbx), "c"(rcx));	\
> +	})
> +
> +#define __encls_ret_3(rax, rbx, rcx, rdx)			\
> +	({							\
> +	__encls_ret_N(rax, "b"(rbx), "c"(rcx), "d"(rdx));	\
> +	})
> +
> +/**
> + * __encls_N - encode an ENCLS leaf that doesn't return an error code
> + * @rax:	leaf number
> + * @rbx_out:	optional output variable
> + * @inputs:	asm inputs for the leaf
> + *
> + * Emit assembly for an ENCLS leaf that does not return an error code,
> + * e.g. ECREATE.  Leaves without error codes either succeed or fault.
> + * @rbx_out is an optional parameter for use by EDGBRD, which returns
> + * the the requested value in RBX.
> + *
> + * Return:
> + *   0 on success,
> + *   trapnr with ENCLS_FAULT_FLAG set on fault
> + */
> +#define __encls_N(rax, rbx_out, inputs...)			\
> +	({							\
> +	int ret;						\
> +	asm volatile(						\
> +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> +	"   xor %%eax,%%eax;\n"					\
> +	"2:\n"							\
> +	".section .fixup,\"ax\"\n"				\
> +	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
> +	"   jmp 2b\n"						\
> +	".previous\n"						\
> +	_ASM_EXTABLE_FAULT(1b, 3b)				\
> +	: "=3Da"(ret), "=3Db"(rbx_out)				\
> +	: "a"(rax), inputs					\
> +	: "memory");						\
> +	ret;							\
> +	})
> +
> +#define __encls_2(rax, rbx, rcx)				\
> +	({							\
> +	unsigned long ign_rbx_out;				\
> +	__encls_N(rax, ign_rbx_out, "b"(rbx), "c"(rcx));	\
> +	})
> +
> +#define __encls_1_1(rax, data, rcx)			\
> +	({						\
> +	unsigned long rbx_out;				\
> +	int ret =3D __encls_N(rax, rbx_out, "c"(rcx));	\
> +	if (!ret)					\
> +		data =3D rbx_out;				\
> +	ret;						\
> +	})
> +
> +static inline int __ecreate(struct sgx_pageinfo *pginfo, void *secs)
> +{
> +	return __encls_2(ECREATE, pginfo, secs);
> +}
> +
> +static inline int __eextend(void *secs, void *addr)
> +{
> +	return __encls_2(EEXTEND, secs, addr);
> +}
> +
> +static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
> +{
> +	return __encls_2(EADD, pginfo, addr);
> +}
> +
> +static inline int __einit(void *sigstruct, void *token, void *secs)
> +{
> +	return __encls_ret_3(EINIT, sigstruct, secs, token);
> +}
> +
> +static inline int __eremove(void *addr)
> +{
> +	return __encls_ret_1(EREMOVE, addr);
> +}
> +
> +static inline int __edbgwr(void *addr, unsigned long *data)
> +{
> +	return __encls_2(EDGBWR, *data, addr);
> +}
> +
> +static inline int __edbgrd(void *addr, unsigned long *data)
> +{
> +	return __encls_1_1(EDGBRD, *data, addr);
> +}
> +
> +static inline int __etrack(void *addr)
> +{
> +	return __encls_ret_1(ETRACK, addr);
> +}
> +
> +static inline int __eldu(struct sgx_pageinfo *pginfo, void *addr,
> +			 void *va)
> +{
> +	return __encls_ret_3(ELDU, pginfo, addr, va);
> +}
> +
> +static inline int __eblock(void *addr)
> +{
> +	return __encls_ret_1(EBLOCK, addr);
> +}
> +
> +static inline int __epa(void *addr)
> +{
> +	unsigned long rbx =3D SGX_PAGE_TYPE_VA;
> +
> +	return __encls_2(EPA, rbx, addr);
> +}
> +
> +static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
> +			void *va)
> +{
> +	return __encls_ret_3(EWB, pginfo, addr, va);
> +}
> +
> +#endif /* _X86_ENCLS_H */
> --=20
> 2.25.1
