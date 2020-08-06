Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EE9C433E0
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CED206C3
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q0LSCRXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgHFRlk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:41:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbgHFRlL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 13:41:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076D2HOa005777;
        Thu, 6 Aug 2020 13:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=5sE9tx5anyYdQsBRy0OTu6KXJ3coyDfCkoAgQh0zTbk=;
 b=q0LSCRXDSxpEefZMaZ/gnUKK2xT2ilGxTe67HdD9UPP/kCdyy0VgXLs1XgXE41rxAK/F
 1/cg2CoxaHQrO69VwjFaU3FksSg+jowCA+PgTFPFLp/bW0eeY+/fDgTGa1ucus6pb91R
 OexjNO6QWy+dDrVmaMGPmM2xLqMAkrGBj90xpjD+i4RQWJW4vR94paI1VjT6v/U6WPVK
 WJod64B1WI3mkoGGIKdLGxPmOw7QlvlcvdjCRN4oQixa9Xa9d4XyM3czGWnvCGd/90I8
 sfxW+72uo8anmBZdTBVaFb1otGnS/wDhXAWISPkIhHn16KCsLnQEdDbL34ExHxKyFrqF gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32r6fxjtsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:16:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076CvpVk071915;
        Thu, 6 Aug 2020 13:16:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32r6cvdb77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:16:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076DGKQ6031849;
        Thu, 6 Aug 2020 13:16:20 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:16:19 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id EED1DF049DA; Thu,  6 Aug 2020 14:16:14 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
In-Reply-To: <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:16:14 +0100
Message-ID: <m2364zsyn5.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=1 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:42 +03, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> a #PF with SGX set happens.
>
> CPU throws a #PF with the SGX set in the event of Enclave Page Cache Map
> (EPCM) conflict. The EPCM is a CPU-internal table, which describes the
> properties for a enclave page. Enclaves are measured and signed software
> entities, which SGX hosts. [1]
>
> Although the primary purpose of the EPCM conflict checks  is to prevent
> malicious accesses to an enclave, an illegit access can happen also for
> legit reasons.
>
> All SGX reserved memory, including EPCM is encrypted with a transient key
> that does not survive from the power transition. Throwing a SIGSEGV allows
> user space software to react when this happens (e.g. recreate the enclave,
> which was invalidated).
>
> [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/include/asm/traps.h | 14 ++++++++------
>  arch/x86/mm/fault.c          | 13 +++++++++++++
>  2 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 714b1a30e7b0..4446f95ad997 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -44,12 +44,13 @@ void __noreturn handle_stack_overflow(const char *message,
>  /*
>   * Page fault error code bits:
>   *
> - *   bit 0 ==	 0: no page found	1: protection fault
> - *   bit 1 ==	 0: read access		1: write access
> - *   bit 2 ==	 0: kernel-mode access	1: user-mode access
> - *   bit 3 ==				1: use of reserved bit detected
> - *   bit 4 ==				1: fault was an instruction fetch
> - *   bit 5 ==				1: protection keys block access
> + *   bit 0  ==	 0: no page found	1: protection fault
> + *   bit 1  ==	 0: read access		1: write access
> + *   bit 2  ==	 0: kernel-mode access	1: user-mode access
> + *   bit 3  ==				1: use of reserved bit detected
> + *   bit 4  ==				1: fault was an instruction fetch
> + *   bit 5  ==				1: protection keys block access
> + *   bit 15 ==				1: inside SGX enclave
>   */
>  enum x86_pf_error_code {
>  	X86_PF_PROT	=		1 << 0,
> @@ -58,5 +59,6 @@ enum x86_pf_error_code {
>  	X86_PF_RSVD	=		1 << 3,
>  	X86_PF_INSTR	=		1 << 4,
>  	X86_PF_PK	=		1 << 5,
> +	X86_PF_SGX	=		1 << 15,
>  };
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 1ead568c0101..1db6fbd7af8e 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1055,6 +1055,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
>  	if (error_code & X86_PF_PK)
>  		return 1;
>  
> +	/*
> +	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> +	 * access is allowed by the PTE but not the EPCM. This usually happens
> +	 * when the EPCM is yanked out from under us, e.g. by hardware after a
> +	 * suspend/resume cycle. In any case, software, i.e. the kernel, can't
> +	 * fix the source of the fault as the EPCM can't be directly modified by
> +	 * software. Handle the fault as an access error in order to signal
> +	 * userspace so that userspace can rebuild their enclave(s), even though
> +	 * userspace may not have actually violated access permissions.
> +	 */
> +	if (unlikely(error_code & X86_PF_SGX))
> +		return 1;
> +
>  	/*
>  	 * Make sure to check the VMA so that we do not perform
>  	 * faults just to hit a X86_PF_PK as soon as we fill in a
> -- 
> 2.25.1
