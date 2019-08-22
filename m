Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1FAC3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 00:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C49D21848
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 00:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfHVAeA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 20:34:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:21106 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfHVAeA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 20:34:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 17:33:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="178669329"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Aug 2019 17:33:58 -0700
Date:   Wed, 21 Aug 2019 17:33:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sgx: Remove duplicate check for entry->epc_page
 in sgx_encl_load_page()
Message-ID: <20190822003358.GO29345@linux.intel.com>
References: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
 <20190821232902.29476-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821232902.29476-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 02:29:01AM +0300, Jarkko Sakkinen wrote:
> The existence of the page is checked first hand for legit race
> conditions (either two or more concurrent threads running the #PF
> handler or the reclaimer has taken over the page):
> 
> /* Page is already resident in the EPC. */
> if (entry->epc_page) {
> 	if (entry->desc & SGX_ENCL_PAGE_RECLAIMED)
> 		return ERR_PTR(-EBUSY);
> 
> 	return entry;
> }
> 
> After that the existence is a checked as a condition for ELDU.
> 
> This commit removes the redundant check.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---

Ha, I remember seeing this a while back and completely forgot about it.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index a20d498e9dcd..d6397f7ef3b8 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -123,7 +123,7 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  			return ERR_CAST(epc_page);
>  	}
>  
> -	epc_page = entry->epc_page ? entry->epc_page : sgx_encl_eldu(entry);
> +	epc_page = sgx_encl_eldu(entry);
>  	if (IS_ERR(epc_page))
>  		return ERR_CAST(epc_page);
>  
> -- 
> 2.20.1
> 
