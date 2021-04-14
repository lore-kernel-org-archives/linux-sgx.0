Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0238C433B4
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C5361249
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhDNLMC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhDNLMB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Apr 2021 07:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D29610FC;
        Wed, 14 Apr 2021 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618398700;
        bh=KX1SZ02IarTRiewFqgMX/53RZEhNicmt1dcaNcNyYho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lt1Wxlbvqa8VcMSNlm8HlLbh75WJjzBJSwLL0Xeff4LcmmbnqxuYV21bHuEkBtYB6
         WPF7yU62NJYdoVElEgcViie4E5ZaxtaPJ1R8RQFkpnYDQgjEBqXYzW/fjgK2oGA7F/
         U/S9tubmMbe7wJhqkwrCRC8RE9sJEH4Yg/C2ha12PO9pmlODYyxZPjmoXyU6IxLZYZ
         55NLy7/K0XQc/AtSSWAUq7EG8+mmMcAuuldOLWwhF1MzhaCbFyTe3dO7hDOaz5BvTF
         J07Kl15fYBq/nXy6gP2McB3Nq+fw9OQeg8giidPwq8I/cS10l1NahD8r31TPmv7+2y
         P4oN4QS3f7cPw==
Date:   Wed, 14 Apr 2021 14:11:37 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] x86/sgx: Make symbol 'sgx_vepc_vm_ops' static
Message-ID: <YHbN6a6rZK/jNQGk@kernel.org>
References: <20210412160023.193850-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412160023.193850-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 12, 2021 at 04:00:23PM +0000, Wei Yongjun wrote:
> The sparse tool complains as follows:
> 
> arch/x86/kernel/cpu/sgx/virt.c:95:35: warning:
>  symbol 'sgx_vepc_vm_ops' was not declared. Should it be static?
> 
> This symbol is not used outside of virt.c, so this
> commit marks it static.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

The only reason I cannot ack this is that instead telling what the
commit does, the long description asks should this be done or not.


/Jarkko

>  arch/x86/kernel/cpu/sgx/virt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 7d221eac716a..6ad165a5c0cc 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -92,7 +92,7 @@ static vm_fault_t sgx_vepc_fault(struct vm_fault *vmf)
>  	return VM_FAULT_SIGBUS;
>  }
>  
> -const struct vm_operations_struct sgx_vepc_vm_ops = {
> +static const struct vm_operations_struct sgx_vepc_vm_ops = {
>  	.fault = sgx_vepc_fault,
>  };
>  
> 
> 
