Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59780C433B4
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 01:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C6A613C1
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 01:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhDNBPa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:15:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:56433 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhDNBP3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 13 Apr 2021 21:15:29 -0400
IronPort-SDR: dikCzMP0PNn8/yjq5SQy/L0E7x7MyxuADzo7mvnfDY0hx5xdl6XqLm9eSi2v3hNPfezllVHC7Z
 KI9+yvjTwLAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="182049681"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="182049681"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 18:15:03 -0700
IronPort-SDR: B4Xn+ZbkfFXtRWDT1D22DdiC7dqMvOjORm2cMGVAjqXfjXpgDCqJXbv1L9qZJyaejdM7jB+PSf
 jjVnvVXsLz/A==
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="424498356"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.254.189.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 13 Apr 2021 18:15:01 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org, "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     dave.hansen@intel.com, "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Jethro Beekman" <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] x86/sgx: Maintain encl->refcount for each
 encl->mm_list entry
References: <20210207221401.29933-1-jarkko@kernel.org>
Date:   Tue, 13 Apr 2021 20:15:09 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.01te3jzwwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20210207221401.29933-1-jarkko@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 07 Feb 2021 16:14:01 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> This has been shown in tests:
>
> [  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374  
> cleanup_srcu_struct+0xed/0x100
>
> This is essentially a use-after free, although SRCU notices it as
> an SRCU cleanup in an invalid context.
>
The comments in code around this warning indicate a potential memory leak.
Not sure how use-after-free come into play. Anyway, this fix seems to work  
for the warning above.

However, I still have doubts on another potential race. See below.


> diff --git a/arch/x86/kernel/cpu/sgx/driver.c  
> b/arch/x86/kernel/cpu/sgx/driver.c
> index f2eac41bb4ff..8ce6d8371cfb 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -72,6 +72,9 @@ static int sgx_release(struct inode *inode, struct  
> file *file)
>  		synchronize_srcu(&encl->srcu);
>  		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
>  		kfree(encl_mm);

Note here you are freeing the encl_mm, outside protection of  
encl->refcount.

> +
> +		/* 'encl_mm' is gone, put encl_mm->encl reference: */
> +		kref_put(&encl->refcount, sgx_encl_release);
>  	}
> 	kref_put(&encl->refcount, sgx_encl_release);
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
> b/arch/x86/kernel/cpu/sgx/encl.c
> index 20a2dd5ba2b4..7449ef33f081 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -473,6 +473,9 @@ static void sgx_mmu_notifier_free(struct  
> mmu_notifier *mn)
>  {
>  	struct sgx_encl_mm *encl_mm = container_of(mn, struct sgx_encl_mm,  
> mmu_notifier);
> +	/* 'encl_mm' is going away, put encl_mm->encl reference: */
> +	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
> +
>  	kfree(encl_mm);

Could this access to and kfree of encl_mm possibly be after the  
kfree(encl_mm) noted above?

Also is there a reason we do kfree(encl_mm) in notifier_free not directly  
in notifier_release?

Thanks
Haitao
