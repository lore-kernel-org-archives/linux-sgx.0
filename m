Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEF1C4743C
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Jun 2021 13:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EBD61351
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Jun 2021 13:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhFWNbE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhFWNbE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Jun 2021 09:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5544761075;
        Wed, 23 Jun 2021 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624454926;
        bh=upqSmdlxULGclKN0RnNpYjn/h2h0AC6b/GP82iBreOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbeERsVc2rDvbpmqhDP/cMdTvV/v+foZuspnwziFzCuY9HIdkFHlIzF6aJLlApiXO
         z4t1fL+71kgzOedoPlDIXxLXgFT+aUDEEfHx+A9TA13VcfHpLtVXozNIgbGrrgH13Y
         P1yeLOua+keo1sTjUQmW7NWVJo/wekxLxg3RWE8i0UQHLUew4tFkPB5ozito+h8ksr
         sUxP5c5bwcRMbxFklNwjyitZnf8JRJhdoBceUzeOks7goeGRr0yXqLLnf3YKWTTYYX
         MGLVGI4daOYjoCF9D0yRIfXwE5k8ENwriGN7VLMSk3XjkXX6Y0K1FhOKmns7X9IY1y
         LkssBkHadEdgQ==
Date:   Wed, 23 Jun 2021 16:28:44 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Subject: Re: [PATCH v2] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
Message-ID: <20210623132844.heleuoxogrpz3cpm@kernel.org>
References: <20210616003634.320206-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616003634.320206-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 16, 2021 at 12:36:34PM +1200, Kai Huang wrote:
> xa_destroy() needs to be called to destroy virtual EPC's page array
> before calling kfree() to free the virtual EPC.  Currently it is not
> called.  Add the missing xa_destroy() to fix.
> 
> Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guests")
> Tested-by: Yang Zhong <yang.zhong@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

> ---
> v1->v2:
> 
>  - Fixed typo in commit msg
>  - Added Dave's Acked-by
> ---
>  arch/x86/kernel/cpu/sgx/virt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6ad165a5c0cc..64511c4a5200 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -212,6 +212,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
>  		list_splice_tail(&secs_pages, &zombie_secs_pages);
>  	mutex_unlock(&zombie_secs_pages_lock);
>  
> +	xa_destroy(&vepc->page_array);
>  	kfree(vepc);
>  
>  	return 0;
> -- 
> 2.31.1
> 
> 

/Jarkko
