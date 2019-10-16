Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1917BFA3728
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 22:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF87821835
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 22:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbfJPWZZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 18:25:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:13818 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbfJPWZZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 18:25:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 15:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="186294314"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga007.jf.intel.com with ESMTP; 16 Oct 2019 15:25:24 -0700
Subject: Re: [PATCH for_v23 3/5] x86/vdso: sgx: Fix unwinder support
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
References: <20191011004059.28581-1-sean.j.christopherson@intel.com>
 <20191011004059.28581-4-sean.j.christopherson@intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <f8db00ae-e2fe-197e-59d0-619e1ad978d5@intel.com>
Date:   Wed, 16 Oct 2019 15:25:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011004059.28581-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 10/10/2019 5:40 PM, Sean Christopherson wrote:
> Relocate the .cfi_endproc directive to the RET that actually returns
> from the vDSO function.  During recent refactoring, it was inadvertantly
> left next to the RET used for the retpoline.
> 
> Reported-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/entry/vdso/vsgx_enter_enclave.S | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index b63091818df1..3dd22780b7ef 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -113,6 +113,7 @@ ENTRY(__vdso_sgx_enter_enclave)
>   	leave
>   	.cfi_def_cfa		%rsp, 8
>   	ret
> +	.cfi_endproc

As mentioned in my other email, the above won't work.

>   
>   .Linvalid_leaf:
>   	mov	$(-EINVAL), %eax
> @@ -176,7 +177,6 @@ ENTRY(__vdso_sgx_enter_enclave)
>   	jmp	1b
>   2:	mov	%rax, (%rsp)
>   	ret
> -	.cfi_endproc
>   
>   _ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
>   
> 
