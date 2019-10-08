Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC55CC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E4B7206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfJHEPi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:15:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:52493 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbfJHEPi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:15:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:15:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="218165711"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 07 Oct 2019 21:15:37 -0700
Date:   Mon, 7 Oct 2019 21:15:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: WARN once if EREMOVE fails when killing an
 enclave
Message-ID: <20191008041537.GB1724@linux.intel.com>
References: <20191008041334.3235-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008041334.3235-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 09:13:34PM -0700, Sean Christopherson wrote:
> WARN if EREMOVE fails when destroying an enclave.  sgx_encl_release()
> uses the non-WARN __sgx_free_page() when freeing pages as some pages may
> be in the process of being reclaimed, i.e. are owned by the reclaimer.
> But EREMOVE should never fail as sgx_encl_destroy() is only called when
> the enclave cannot have active threads, e.g. prior to EINIT and when the
> enclave is being released.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 54ca827e68a9..a6786e7ae40e 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -463,16 +463,23 @@ void sgx_encl_destroy(struct sgx_encl *encl)
>  	struct sgx_encl_page *entry;
>  	struct radix_tree_iter iter;
>  	void **slot;
> +	int r;
>  
>  	atomic_or(SGX_ENCL_DEAD, &encl->flags);
>  
>  	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
>  		entry = *slot;
>  		if (entry->epc_page) {
> -			if (!__sgx_free_page(entry->epc_page)) {
> +			/*
> +			 * Freeing the page can fail if it's in the process of
> +			 * being reclaimed (-EBUSY), but EREMOVE itself should
> +			 * not fail at this point.
> +			 */
> +			r = __sgx_free_page(entry->epc_page);
> +			WARN_ONCE(r > 0, "sgx: EREMOVE returned %d (0x%x)", r, r);
> +			if (!r) {
>  				encl->secs_child_cnt--;
>  				entry->epc_page = NULL;
> -
>  			}
>  
>  			radix_tree_delete(&entry->encl->page_tree,
> -- 
> 2.22.0

Intended for v23, forgot to tag the subject...
