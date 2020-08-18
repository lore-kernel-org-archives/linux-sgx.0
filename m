Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4084CC433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C63A20786
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgHRQ7p (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:59:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:16645 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgHRQ5x (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 12:57:53 -0400
IronPort-SDR: hK87mjq6+3AOnCTFPVpzR1AH2B6k8o/zLzLRjEHbXlZKfC5clCqGNfusgQRqftpH8ZYKYRUc/C
 bJfq1qYTYcAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152364366"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="152364366"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 09:57:48 -0700
IronPort-SDR: M6w1U0xYn1T4vri8Fy8A4pJvak+Qi11X5CY/Eqder7ql+TAqkFMraJw+LAlnlVwwiTz3RnwOBP
 IIj23TiGkX9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="326791136"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2020 09:57:46 -0700
Date:   Tue, 18 Aug 2020 19:57:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200818165745.GB138452@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818042405.12871-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 17, 2020 at 09:24:03PM -0700, Sean Christopherson wrote:
> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
> output params.  In the new struct, add an opaque "user_data" that can be
> used to pass context across the vDSO, and an explicit "exit_reason" to
> avoid overloading the return value.
> 
> Moving the params into a struct will also make it less painful to use
> dedicated exit reasons, and to support exiting on interrupts in future
> patches.
> 
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 72 ++++++++++++-------
>  arch/x86/include/uapi/asm/sgx.h          | 90 ++++++++++++++++--------
>  2 files changed, 107 insertions(+), 55 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 2d88acd408d4e..aaae6d6e28ac3 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -7,9 +7,21 @@
>  
>  #include "extable.h"
>  
> -#define EX_LEAF		0*8
> -#define EX_TRAPNR	0*8+4
> -#define EX_ERROR_CODE	0*8+6
> +/* Offset of 'struct sgx_enter_enclave' relative to %rbp. */
> +#define RUN_OFFSET	2*8

Some better name please.

> +
> +/* Offsets into 'struct sgx_enter_enclave'. */
> +#define TCS_OFFEST		0*8
> +#define FLAGS_OFFSET		1*8
> +#define EXIT_LEAF_OFFSET	2*8
> +#define EXIT_REASON_OFFSET	2*8 + 4
> +#define USER_HANDLER_OFFSET	3*8
> +/* #define USER_DATA_OFFSET	4*8 */
> +#define EXCEPTION_OFFSET	5*8

These non-prefixed constants make the code really stressing to read
given the complexity of it. Please, just write them like
SGX_ENTER_ENCLAVE_TCS and so forth.

/Jarkko
