Return-Path: <SRS0=7mz1=7M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652E3C433DF
	for <linux-sgx@archiver.kernel.org>; Sat, 30 May 2020 08:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4830820776
	for <linux-sgx@archiver.kernel.org>; Sat, 30 May 2020 08:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgE3Ink (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 May 2020 04:43:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:51094 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgE3Inj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 May 2020 04:43:39 -0400
IronPort-SDR: FX3pqyO2cQNdBQ6uKDThdANEx+I+qHqJeR7FscAACpkIV31KMdrs7Hl4rbRLzE5Z2Uw0HSm4oW
 RAhExkCs0c2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 01:43:39 -0700
IronPort-SDR: NKAPvT2pzliNbc/BcrRquNdSrwB6Qr6/khvQq1H4rSc3Efn+bvHYpmBv7bL4agDizQuq3Bj1FO
 c5BHRM2QI7lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,451,1583222400"; 
   d="scan'208";a="285773056"
Received: from elang-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.42.245])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2020 01:43:37 -0700
Date:   Sat, 30 May 2020 11:43:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 2/6] x86/sgx: Remove unnecessary globals after
 merging reclaim.c into main.c
Message-ID: <20200530084336.GA4896@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175407.2109-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 10:54:03AM -0700, Sean Christopherson wrote:
> Make all variables that are only used in main.c static, rearranging code
> as needed.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

As with merging, it is a multiphase process to make these changes.

I.e. I'll do manually similar changes but cannot use this patch for
anything.

/Jarkko

> ---
>  arch/x86/kernel/cpu/sgx/main.c | 16 ++++++----------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ---
>  2 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 5043d3700960b..ef7061bfa2a07 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -14,9 +14,12 @@
>  #include "encls.h"
>  
>  static struct task_struct *ksgxswapd_tsk;
> -DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> -LIST_HEAD(sgx_active_page_list);
> -DEFINE_SPINLOCK(sgx_active_page_list_lock);
> +static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> +static LIST_HEAD(sgx_active_page_list);
> +static DEFINE_SPINLOCK(sgx_active_page_list_lock);
> +
> +struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> +static int sgx_nr_epc_sections;
>  
>  static void sgx_sanitize_section(struct sgx_epc_section *section)
>  {
> @@ -45,10 +48,6 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
>  	}
>  }
>  
> -extern struct task_struct *ksgxswapd_tsk;
> -extern struct wait_queue_head(ksgxswapd_waitq);
> -extern spinlock_t sgx_active_page_list_lock;
> -
>  static unsigned long sgx_nr_free_pages(void)
>  {
>  	unsigned long cnt = 0;
> @@ -491,9 +490,6 @@ void sgx_reclaim_pages(void)
>  	}
>  }
>  
> -struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> -int sgx_nr_epc_sections;
> -
>  static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
>  {
>  	struct sgx_epc_page *page;
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 923028d568540..5b9dbcef981b0 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -41,14 +41,11 @@ struct sgx_epc_section {
>  #define SGX_NR_LOW_PAGES		32
>  #define SGX_NR_HIGH_PAGES		64
>  
> -extern struct list_head sgx_active_page_list;
> -
>  void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
>  int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
>  void sgx_reclaim_pages(void);
>  
>  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> -extern int sgx_nr_epc_sections;
>  
>  static inline struct sgx_epc_section *sgx_get_epc_section(
>  		struct sgx_epc_page *page)
> -- 
> 2.26.0
> 
