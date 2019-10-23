Return-Path: <SRS0=0rGN=YQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A277CA9EC0
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 12:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 256AF21906
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 12:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391772AbfJWMov (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:44:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:29645 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391686AbfJWMou (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Oct 2019 08:44:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 05:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="228112146"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.121])
  by fmsmga002.fm.intel.com with ESMTP; 23 Oct 2019 05:44:49 -0700
Date:   Wed, 23 Oct 2019 15:44:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 1/3] x86/sgx: Update the free page count in a
 single operation
Message-ID: <20191023124449.GH23733@linux.intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
 <20191022224922.28144-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022224922.28144-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 22, 2019 at 03:49:20PM -0700, Sean Christopherson wrote:
> Use atomic_add() instead of running atomic_inc() in a loop to manually
> do the equivalent addition.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 499a9b0740c8..d45bf6fca0c8 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -195,8 +195,7 @@ static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
>  		list_add_tail(&page->list, &section->unsanitized_page_list);
>  	}
>  
> -	for (i = 0; i < nr_pages; i++)
> -		atomic_inc(&sgx_nr_free_pages);
> +	atomic_add(nr_pages, &sgx_nr_free_pages);
>  
>  	return true;
>  
> -- 
> 2.22.0
> 

There reason I used atomic_inc() was that atomic_add() takes int that
could potentially overflow.

I'll ignore this as I'll do the revert that I promised to do.

/Jarkko
