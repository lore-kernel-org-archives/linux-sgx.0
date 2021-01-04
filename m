Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6511CC433DB
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Jan 2021 20:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285DA2226A
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Jan 2021 20:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbhADUYg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:24:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:54162 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbhADUYg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Jan 2021 15:24:36 -0500
IronPort-SDR: dLP1AfQ8zAxGTJCyMI77hXMD4+ln8Ht8/fMNYlIYBLBTukjdKM4zLDfWkC3QSAbd7cjn5+b1TP
 hS6+gAvUl3xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="176222394"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="176222394"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 12:22:50 -0800
IronPort-SDR: iQr5yQm8p1XD6tguWyuBU3KSJJzbRg7VkZlLD1wAFmCadrILFeWn1Jf2d5FfyjfNqy58h66Qiv
 n17tEiU7NPyg==
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="378562801"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.209.116.234])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 04 Jan 2021 12:22:49 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     x86@kernel.org, "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        "Sean Christopherson" <seanjc@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jethro Beekman" <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
References: <20201216134920.21161-1-jarkko@kernel.org>
Date:   Mon, 04 Jan 2021 14:22:05 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0wppi8q8wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20201216134920.21161-1-jarkko@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 16 Dec 2020 07:49:20 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> period initiated by sgx_mmu_notifier_release().
>
> A trivial example of a failing sequence with tasks A and B:
>
> 1. A: -> sgx_release()
> 2. B: -> sgx_mmu_notifier_release()
> 3. B: -> list_del_rcu()
> 3. A: -> sgx_encl_release()
> 4. A: -> cleanup_srcu_struct()
>
> The loop in sgx_release() observes an empty list because B has removed  
> its
> entry in the middle, and calls cleanup_srcu_struct() before B has a  
> chance
> to calls synchronize_srcu().
>
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v3: Fine-tuned tags, and added missing change log for v2.
> v2: Switch to synchronize_srcu_expedited().
>  arch/x86/kernel/cpu/sgx/encl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
> b/arch/x86/kernel/cpu/sgx/encl.c
> index ee50a5010277..fe7256db6e73 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -438,6 +438,12 @@ void sgx_encl_release(struct kref *ref)
>  	if (encl->backing)
>  		fput(encl->backing);
> +	/*
> +	 * Each sgx_mmu_notifier_release() starts a grace period. Therefore, an
> +	 * additional sync is required here.
> +	 */
> +	synchronize_srcu_expedited(&encl->srcu);
> +
>  	cleanup_srcu_struct(&encl->srcu);
> 	WARN_ON_ONCE(!list_empty(&encl->mm_list));

Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
Thanks
Haitao
