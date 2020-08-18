Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70465C433E3
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5975A207DE
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgHRQ65 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:58:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:16738 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgHRQ6r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 12:58:47 -0400
IronPort-SDR: cxoBNNA/yv+eg79DmhewKA+9+11hEi1fh3+cgl4PxPGi/dOa/DUpRzWg/erazW3v+miGGHT/jx
 dirS7mxw/dpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152364780"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="152364780"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 09:58:45 -0700
IronPort-SDR: P8dt7r0k/Se08UVHJOL6Hf3FB+lBHESoK0ZVAQJF1n2iPsusniU0d2Wf13TPhVV3SMW6g4ET5P
 Kk5DOIDiOsRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471882693"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by orsmga005.jf.intel.com with ESMTP; 18 Aug 2020 09:58:38 -0700
Date:   Tue, 18 Aug 2020 19:58:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] x86/vdso: x86/sgx: Introduce dedicated SGX exit
 reasons for vDSO
Message-ID: <20200818165838.GC138452@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818042405.12871-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 17, 2020 at 09:24:04PM -0700, Sean Christopherson wrote:
> Use dedicated exit reasons, e.g. SYNCHRONOUS and EXCEPTION, instead of
> '0' and '-EFAULT' respectively.  Using -EFAULT is less than desirable as
> it usually means "bad address", which may or may not be true for a fault
> in the enclave or on ENCLU.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 7 +++++--
>  arch/x86/include/uapi/asm/sgx.h          | 3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index aaae6d6e28ac3..b09e87dbe9334 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -19,6 +19,9 @@
>  /* #define USER_DATA_OFFSET	4*8 */
>  #define EXCEPTION_OFFSET	5*8
>  
> +#define SGX_SYNCHRONOUS_EXIT	0
> +#define SGX_EXCEPTION_EXIT	1
> +
>  /* Offsets into sgx_enter_enclave.exception. */
>  #define EX_TRAPNR	0*8
>  #define EX_ERROR_CODE	0*8+2
> @@ -65,7 +68,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	mov	RUN_OFFSET(%rbp), %rbx
>  
>  	/* Set exit_reason. */
> -	movl	$0, EXIT_REASON_OFFSET(%rbx)
> +	movl	$SGX_SYNCHRONOUS_EXIT, EXIT_REASON_OFFSET(%rbx)
>  
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> @@ -94,7 +97,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	mov	RUN_OFFSET(%rbp), %rbx
>  
>  	/* Set the exit_reason and exception info. */
> -	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
> +	movl	$SGX_EXCEPTION_EXIT, EXIT_REASON_OFFSET(%rbx)
>  
>  	mov	%di,  (EXCEPTION_OFFSET + EX_TRAPNR)(%rbx)
>  	mov	%si,  (EXCEPTION_OFFSET + EX_ERROR_CODE)(%rbx)
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index d3b107aac279d..80a8b7a949a23 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,6 +74,9 @@ struct sgx_enclave_set_attribute {
>  	__u64 attribute_fd;
>  };
>  
> +#define SGX_SYNCHRONOUS_EXIT	0
> +#define SGX_EXCEPTION_EXIT	1

enum would be great here.

> +
>  struct sgx_enclave_run;
>  
>  /**
> -- 
> 2.28.0
> 

/Jarkko
