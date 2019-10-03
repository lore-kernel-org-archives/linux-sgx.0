Return-Path: <SRS0=vH/k=X4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90DEC10F14
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 22:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A68920867
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 22:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfJCWHl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Oct 2019 18:07:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:3937 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJCWHl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Oct 2019 18:07:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 15:07:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="393351009"
Received: from okiselev-mobl1.ccr.corp.intel.com (HELO localhost) ([10.251.93.117])
  by fmsmga006.fm.intel.com with ESMTP; 03 Oct 2019 15:07:39 -0700
Date:   Fri, 4 Oct 2019 01:07:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2] x86/sgx: Migrate to mmu_notifier_put()
Message-ID: <20191003220737.GB30986@linux.intel.com>
References: <20191003170423.6221-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003170423.6221-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 03, 2019 at 08:04:23PM +0300, Jarkko Sakkinen wrote:
> Use mmu_notifier_put() to synchronize sgx_encl_mm deletion.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> v2:
> * Was not thinking clearly that we also use it for lockless
>   operation on the mm list. Just migrating to mmu_notifier_put().
>   Please ignore the previous patch!
>  arch/x86/kernel/cpu/sgx/encl.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index d145360380d5..8cc9ea353bee 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -131,14 +131,6 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  	return entry;
>  }
>  
> -static void sgx_encl_mm_release_deferred(struct rcu_head *rcu)
> -{
> -	struct sgx_encl_mm *encl_mm =
> -		container_of(rcu, struct sgx_encl_mm, rcu);
> -
> -	kfree(encl_mm);
> -}
> -
>  static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
>  				     struct mm_struct *mm)
>  {
> @@ -161,19 +153,21 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
>  
>  	if (tmp == encl_mm) {
>  		synchronize_srcu(&encl_mm->encl->srcu);
> -
> -		/*
> -		 * Delay freeing encl_mm until after mmu_notifier synchronizes
> -		 * its SRCU to ensure encl_mm cannot be dereferenced.
> -		 */
> -		mmu_notifier_unregister_no_release(mn, mm);
> -		mmu_notifier_call_srcu(&encl_mm->rcu,
> -				       &sgx_encl_mm_release_deferred);
> +		mmu_notifier_put(mn);
>  	}
>  }
>  
> +static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(mn, struct sgx_encl_mm, mmu_notifier);
> +
> +	kfree(encl_mm);
> +}
> +
>  static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
>  	.release		= sgx_mmu_notifier_release,
> +	.free_notifier		= sgx_mmu_notifier_free,
>  };
>  
>  static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
> -- 
> 2.20.1
> 

This one I squashed (master updated).

/Jarkko
