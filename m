Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B80FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29472206B5
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 16:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgHRQq5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:46:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:15381 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgHRQqz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 12:46:55 -0400
IronPort-SDR: aetnjx2t929SC/gLwUE0Ky2e2Gk5yRRkiNOcjq4Sgc8XyYWPrU5FwNT0slEx1AWuRzR7cGdJo2
 1tycSzuu/MEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152361977"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="152361977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 09:46:55 -0700
IronPort-SDR: Z+11w0P8jDPNeRDL4jI53SXnWibXYA+vnneIgcDUSaEYX7qQN57s9pNex+N9wO0IE+zf535hk5
 JjHJolbyCT6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="497430684"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2020 09:46:53 -0700
Date:   Tue, 18 Aug 2020 19:46:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] x86/vdso: x86/sgx: Explicitly force 8-byte CMP
 for detecting user handler
Message-ID: <20200818164652.GA138452@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818042405.12871-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 17, 2020 at 09:24:02PM -0700, Sean Christopherson wrote:
> Use 'cmpq' to force an 8-byte CMP when checking for a user provided exit
> handler.  The handler is a pointer, which is guaranteed to be an 8-byte
> value since SGX is 64-bit mode only, and gcc defaults to 'cmpl' given a
> bare 'cmp', i.e. is only checking the lower 32 bits.  This could cause
> a false negative when detecting a user exit handler.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index be7e467e1efb3..2d88acd408d4e 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -48,7 +48,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> -	cmp	$0, 0x20(%rbp)
> +	cmpq	$0, 0x20(%rbp)
>  	jne	.Linvoke_userspace_handler
>  
>  .Lout:
> -- 
> 2.28.0
> 

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

BR,
/Jarkko
