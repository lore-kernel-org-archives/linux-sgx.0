Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43ADEC742A8
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD78217D9
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfGLEAI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Jul 2019 00:00:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:55441 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfGLEAI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Jul 2019 00:00:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 21:00:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="365041169"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jul 2019 21:00:06 -0700
Date:   Fri, 12 Jul 2019 07:00:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21] x86/vdso: Do not attempt to fixup #DB or #BP
 exceptions
Message-ID: <20190712040002.lyyfpxwy2gvxxy63@linux.intel.com>
References: <20190711214751.16725-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711214751.16725-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 02:47:51PM -0700, Sean Christopherson wrote:
> Do not fixup #DB or #BP exceptions that are reported on the SGX vDSO's > ENCLU, as it's impossible to determine whether or not the exception
> originated from within an enclave, e.g. a #DB in an enclave will look
> identical to a #DB on the ENCLU itself.  Even if hardware provided a
> magic flag to identify enclave exceptions, #DB still has scenarios where
> the intended recipient is ambiguous, e.g. a data breakpoint encountered
> in the enclave but on an address outside of the enclave, a breakpoint
> encountered in the enclave and a simultaneouls code breakpoint on ENCLU,
> and so on and so forth.
> 
> An alternative solution would be to simply not call the vDSO fixup
> routine for #DB or #BP.  Rejecting fixup from within vDSO explicitly
> documents that #DB/#BP are intentionally skipped and provides a single
> location for determining what exceptions are indeed handled by vDSO
> fixup.

I think this is better and good use of the boolean return value i.e.
consolidate the decision to a single place.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/extable.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/entry/vdso/extable.c b/arch/x86/entry/vdso/extable.c
> index 49284d560d36..afcf5b65beef 100644
> --- a/arch/x86/entry/vdso/extable.c
> +++ b/arch/x86/entry/vdso/extable.c
> @@ -2,6 +2,7 @@
>  #include <linux/err.h>
>  #include <linux/mm.h>
>  #include <asm/current.h>
> +#include <asm/traps.h>
>  #include <asm/vdso.h>
>  
>  struct vdso_exception_table_entry {
> @@ -16,6 +17,14 @@ bool fixup_vdso_exception(struct pt_regs *regs, int trapnr,
>  	unsigned int nr_entries, i;
>  	unsigned long base;
>  
> +	/*
> +	 * Do not attempt to fixup #DB or #BP.  It's impossible to identify
> +	 * whether or not a #DB/#BP originated from within an SGX enclave and
> +	 * SGX enclaves are currently the only use case for vDSO fixup.
> +	 */
> +	if (trapnr == X86_TRAP_DB || trapnr == X86_TRAP_BP)
> +		return false;
> +
>  	if (!current->mm->context.vdso)
>  		return false;
>  
> -- 
> 2.22.0
> 

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
