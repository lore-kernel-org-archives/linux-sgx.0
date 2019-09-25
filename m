Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F635C432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 765A021D7A
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408550AbfIYS22 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:28:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:15056 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408520AbfIYS22 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 14:28:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 11:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="273051579"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 25 Sep 2019 11:28:27 -0700
Date:   Wed, 25 Sep 2019 11:28:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 13/17] x86/sgx: Introduce sgx_can_reclaim()
Message-ID: <20190925182827.GA32372@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-14-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916101803.30726-14-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 16, 2019 at 01:17:59PM +0300, Jarkko Sakkinen wrote:
> Make sgx_reclaim_evict() idempotennt and rename it to sgx_can_reclaim() and
> set SGX_ENCL_PAGE_RECLAIMED in the call site.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/reclaim.c | 32 +++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> index 5a4d44dd02d7..cc3155b61513 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -121,7 +121,19 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
>  	spin_unlock(&sgx_active_page_list_lock);
>  }
>  
> -static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
> +/**
> + * sgx_can_reclaim() - Filter out the pages that should not be reclaimed
> + * @epc_page:	a candidate EPC page
> + *
> + * Do not reclaim this page if it has been recently accessed by any mm_struct
> + * *and* if the enclave is still alive.  No need to take the enclave's lock,
> + * worst case scenario reclaiming pages from a dead enclave is delayed slightly.
> + * A live enclave with a recently accessed page is more common and avoiding lock
> + * contention in that case is a boon to performance.
> + *
> + * Return: true if the page should be reclaimed
> + */
> +static bool sgx_can_reclaim(struct sgx_epc_page *epc_page)

Belated thought.  The param can be 'struct sgx_encl_page *encl_page'.  The
caller already has the encl_page, and the function only uses the epc_page
to retrieve the encl_page.
