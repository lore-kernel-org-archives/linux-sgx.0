Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA1CC48BE5
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 13:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7C961474
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 13:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhFONWI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 09:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFONWI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Jun 2021 09:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED1661465;
        Tue, 15 Jun 2021 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623763204;
        bh=OcP4vYJ90ya1m4qnaGcSBxiNo8C9gncyaFzfEYJ21Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARLiQxWHLeRLe+TGPlYNOQKxxrQQ9Pco4n9l9cg3skZXE1CtqLVV1ePbjuqHqSfHX
         VRY++wpBZ3iuKmVj8wg7ymFFnneg73CcrDTqH3RpQ3MySB5jhKjldRNWOvZin5UOkA
         1r60aNbAxmKFHqmklsJg1IKEJuczGJtrokgCpfDfEWNteVuj1t0qu8eruziSxWB4m+
         mWntFShrnIWKWQE7eLkYLhxSNSz5P3llKBPPZXACBzeVkR3NZAoz0ZpyPdmBBo+DzF
         1gsdwltxGqsTfOgN6aKPHzbtnDYgbKrzSdiHkMUFrGQ5c4uao8lR2XLDooFqlqcAwi
         oepcF9e62swYg==
Date:   Tue, 15 Jun 2021 16:20:01 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Subject: Re: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
Message-ID: <20210615132001.kd6cuktq37dvoq3l@kernel.org>
References: <20210615101639.291929-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615101639.291929-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 15, 2021 at 10:16:39PM +1200, Kai Huang wrote:
> xa_destroy() needs to be called to destroy virtual EPC's page arra
                                                                    y

> before calling kfree() to free the virtual EPC.  Currently it is not
> calaled.  Add the missing xa_destroy() to fix.
  called

> Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guests")
> Tested-by: Yang Zhong <yang.zhong@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
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
