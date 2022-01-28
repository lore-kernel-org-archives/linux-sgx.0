Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D108AC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jan 2022 18:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbiA1S0e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:26:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:28015 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348965AbiA1S0e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Jan 2022 13:26:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643394394; x=1674930394;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=ZNFALw1NYgLOvQNdOffNOqnUI9IT8EvUd+ud55cUqKQ=;
  b=GnpDt9EcAVuuPyTkuxHr8Y3hHKzJoyIg7i8xpMl1pBDYMv/q2EPqEnGk
   7rPvFwQXH/BxjL7Spxw2JigKE1OUU2iVgBLPUgDCtx7LU5kFlEZbjQi3W
   MV/KJlkTYjHpxTQ1qhV4XslbBNZqT9hbeeKkuxXJshWpzdDUUIlDd189b
   rZyVLuBVCRaYGWQa6kJV4g/yAmZEmPECy6IRWMitDBavUpfda/KGkReaI
   EF57h9uqTs4fXDFjy+W052RDTf6k0NguS159ysiI+wRl5w+VJ5/o24uOR
   yRSjYm86ZcHwwiT2lZ/62Nr0uqkE1kY0omzj2LYz3hsz1Hj6ajpChdPU6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="246945509"
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="246945509"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 10:26:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="697175321"
Received: from zhenkuny-mobl2.amr.corp.intel.com (HELO [10.209.84.59]) ([10.209.84.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 10:26:33 -0800
Message-ID: <b8255288-69e7-379d-45c3-12f0c2085f19@intel.com>
Date:   Fri, 28 Jan 2022 10:26:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.2
Content-Language: en-US
To:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@linux.intel.com, jarkko@kernel.org
References: <20220126191711.4917-1-kristen@linux.intel.com>
 <20220126191711.4917-3-kristen@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 2/2] x86/sgx: Allow sgx_reclaim_pages() to report failure
In-Reply-To: <20220126191711.4917-3-kristen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 1/26/22 11:17, Kristen Carlson Accardi wrote:
> If backing pages are not able to be allocated during
> sgx_reclaim_pages(), return an error code to the caller.
> sgx_reclaim_pages() can be called from the reclaimer thread,
> or when adding pages via an ioctl. When it is called from the

ioctl() is a function name.  Please add parenthesis to make that clear,
just like any other function name.

> kernel thread, it's safe to ignore the return value, however,
> calls from the ioctls should forward the error.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c4030fb608c6..0e95f69ebcb7 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -377,17 +377,18 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>   * problematic as it would increase the lock contention too much, which would
>   * halt forward progress.
>   */
> -static void sgx_reclaim_pages(void)
> +static int sgx_reclaim_pages(void)
>  {
>  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>  	struct sgx_backing backing[SGX_NR_TO_SCAN];
>  	struct sgx_epc_section *section;
>  	struct sgx_encl_page *encl_page;
> +	int pages_being_reclaimed = 0;
>  	struct sgx_epc_page *epc_page;
>  	struct sgx_numa_node *node;
>  	pgoff_t page_index;
>  	int cnt = 0;
> -	int ret;
> +	int ret = 0;
>  	int i;
>  
>  	spin_lock(&sgx_reclaimer_lock);
> @@ -422,6 +423,8 @@ static void sgx_reclaim_pages(void)
>  		if (ret)
>  			goto skip;
>  
> +		pages_being_reclaimed++;

I think we can do better on the naming there.  Yes, this is number of
pages which have 'SGX_ENCL_PAGE_BEING_RECLAIMED' set, but what does that
*mean*?  What are the implications?

For instance, 'backing_pages_allocated' would imply that there are
future backing pages to use (or clean up).

>  		mutex_lock(&encl_page->encl->lock);
>  		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
>  		mutex_unlock(&encl_page->encl->lock);
> @@ -437,6 +440,9 @@ static void sgx_reclaim_pages(void)
>  		chunk[i] = NULL;
>  	}
>  
> +	if (!pages_being_reclaimed)
> +		return ret;

I think this needs a comment.  It will return the error from the *last*
failure of sgx_encl_get_backing().  That's fine, I guess, but it's a bit
weird because there could have been 100 errors and the first 99 errors
are ignored.

>  	for (i = 0; i < cnt; i++) {
>  		epc_page = chunk[i];
>  		if (epc_page)
> @@ -463,6 +469,7 @@ static void sgx_reclaim_pages(void)
>  		spin_unlock(&node->lock);
>  		atomic_long_inc(&sgx_nr_free_pages);
>  	}
> +	return ret;
>  }


Let's say cnt=2.  The first run through the loop does
sgx_encl_get_backing() and increments pages_being_reclaimed.  The second
run through the loop hits an error, sets ret=-ESOMETHING.  The loop
terminates.

	if (!pages_being_reclaimed) <-- false
		return ret;

	... keep running

Then, we get to the bottom of the function.  One page was reclaimed.
Success!  But, ret=-ESOMETHING.  sgx_reclaim_pages() will return an error.

Right?

I think this is structured wrong.  In the end, we want to know whether
sgx_reclaim_pages() made any progress.  Let's have it return *that*.
How many pages did it successfully reclaim?

That has some really nice properties, especially if we wait until the
last possible moment to manipulate the count.  Perhaps:

static int sgx_reclaim_pages(void)
{
	...
	int nr_pages_reclaimed = 0;
	...

	// The last loop:
        for (i = 0; i < cnt; i++) {
                epc_page = chunk[i];
                if (!epc_page)
                        continue;
		...
                atomic_long_inc(&sgx_nr_free_pages);
		nr_pages_reclaimed++
        }

	return nr_pages_reclaimed;
}

That makes it *blatantly* obvious what the function returns since the
only manipulation of 'nr_pages_reclaimed' is right next to the return.
It also makes the function resilient to any new points of failure.
Let's say that we want to check for sgx_reclaimer_block() failures.
With this patch's approach, we have to add a new check and return for
"pages_being_reclaimed", or even an entirely new counter.

With the approach I'm suggesting, it "just works".

>  static bool sgx_should_reclaim(unsigned long watermark)
> @@ -636,6 +643,7 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
>  struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>  {
>  	struct sgx_epc_page *page;
> +	int ret;
>  
>  	for ( ; ; ) {
>  		page = __sgx_alloc_epc_page();
> @@ -657,7 +665,11 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>  			break;
>  		}
>  
> -		sgx_reclaim_pages();
> +		ret = sgx_reclaim_pages();
> +		if (ret) {
> +			page = ERR_PTR(-ENOMEM);
> +			break;
> +		}
>  		cond_resched();
>  	}

So, we go to the trouble of plumbing a real error code out of
sgx_reclaim_pages(), but then throw it away here.  Why?

