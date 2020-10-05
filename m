Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94383C4363D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1FF207BC
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJED1u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 23:27:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:56753 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJED1u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 23:27:50 -0400
IronPort-SDR: BG29/vvyhHxYm5WtLbCQRXYFdJqU+ps8OjOcfl6AAHEaWU/VdFrnCbpYGiAuf3aQV5TmdooGMj
 5M/2TYBhowPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="227458659"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="227458659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:27:47 -0700
IronPort-SDR: ECfYkgU/8L5YniXt3ECya8pYDvuKF4eU5HtcHGgXSTggz15fcFb1eu/slJhNw4nbNV71PUoe+T
 BfYTqO114jMg==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="523296806"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.36.21])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 04 Oct 2020 20:27:46 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Matthew Wilcox" <willy@infradead.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Fix sgx_encl_may_map locking
References: <20201005004120.105849-1-jarkko.sakkinen@linux.intel.com>
Date:   Sun, 04 Oct 2020 22:27:43 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0rzvwhr9wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20201005004120.105849-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 04 Oct 2020 19:41:20 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> Fix the issue further discussed in:
>
> 1.  
> https://lore.kernel.org/linux-sgx/op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com/
> 2.  
> https://lore.kernel.org/linux-sgx/20201003195440.GD20115@casper.infradead.org/
>
> Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
> b/arch/x86/kernel/cpu/sgx/encl.c
> index ae45f8f0951e..a225e96c7a39 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -304,11 +304,10 @@ int sgx_encl_may_map(struct sgx_encl *encl,  
> unsigned long start,
>  		     unsigned long end, unsigned long vm_flags)
>  {
>  	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
> -	unsigned long idx_start = PFN_DOWN(start);
> -	unsigned long idx_end = PFN_DOWN(end - 1);
> +	unsigned long start_i = PFN_DOWN(start);
> +	unsigned long end_i = PFN_DOWN(end - 1);
>  	struct sgx_encl_page *page;
> -
> -	XA_STATE(xas, &encl->page_array, idx_start);
> +	int i;
> 	/*
>  	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
> @@ -317,9 +316,14 @@ int sgx_encl_may_map(struct sgx_encl *encl,  
> unsigned long start,
>  	if (current->personality & READ_IMPLIES_EXEC)
>  		return -EACCES;
> -	xas_for_each(&xas, page, idx_end)
> +	for (i = start_i; i <= end_i; i++) {
> +		mutex_lock(&encl->lock);
> +		page = xa_load(&encl->page_array, i);
> +		mutex_unlock(&encl->lock);
> +
>  		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
>  			return -EACCES;
> +	}
> 	return 0;
>  }

Works with no PROVE_LOCKING complaints.
Haitao
