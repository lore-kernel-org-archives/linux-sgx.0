Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA18C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 23:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349370AbiEKXd5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 19:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiEKXd4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 19:33:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F114B62100
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 16:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652312035; x=1683848035;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oOGCMxnK8u+hidz7SLBysDrFyVSsq4wPop8JO+N9oLE=;
  b=Ud/tIYb2U01TuEscp9zHQFqe7WyLUlm+YiVVDaOd9pnUoHKQ8oDgasZl
   4otNd8brNC70/3o5CWsXtpE4YHo0PBqrJ1DmP3tDdqQUQyxMry6fd0icM
   ChiZkYLQsSRv/KYhfUMTOgiAxTXOMH6fbu546sdOgwYbnvAxkEmpT/TEo
   VDEpa/oZ11vrVYOhGGXznuuZMeVGtvbwD00oh7owdPL9lvF2B4iGyCi/3
   B6AnyUERL3JgmCdVYwbBcCEoVEYOLh2NYWeR8uh6eE/AdyaWN/MvGa8x8
   FTRIrblFkoK7LAHgCAnG+XklQlYDgIZzYWU6vMMEG0jwwbrCE7sCp1NMn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="295085486"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="295085486"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 16:33:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="697788031"
Received: from destipon-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.148])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 16:33:53 -0700
Message-ID: <c6b002cc4b6f979ffd0869f80742896fbe668376.camel@intel.com>
Subject: Re: [PATCH 3/4] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com
Date:   Thu, 12 May 2022 11:33:51 +1200
In-Reply-To: <20220510031748.3181459-1-zhiquan1.li@intel.com>
References: <20220510031748.3181459-1-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2022-05-10 at 11:17 +0800, Zhiquan Li wrote:
> When VM guest access a SGX EPC page with memory failure, current
> behavior will kill the guest, expected only kill the SGX application
> inside it.
> 
> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> information for hypervisor to inject #MC information to guest, which is
> helpful in SGX case.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 8e4bc6453d26..81801ab0009e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -710,6 +710,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
>  	struct sgx_epc_section *section;
>  	struct sgx_numa_node *node;
> +	struct sgx_vepc_page *owner;
> +	int ret = 0;
>  
>  	/*
>  	 * mm/memory-failure.c calls this routine for all errors
> @@ -726,8 +728,22 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	 * error. The signal may help the task understand why the
>  	 * enclave is broken.
>  	 */
> -	if (flags & MF_ACTION_REQUIRED)
> -		force_sig(SIGBUS);
> +	if (flags & MF_ACTION_REQUIRED) {
> +		/*
> +		 * In case the error memory is accessed by VM guest, provide
> +		 * extra info for hypervisor to make further decision but not
> +		 * simply kill it.
> +		 */
> +		if (page->flags & SGX_EPC_PAGE_IS_VEPC) {
> +			owner = (struct sgx_vepc_page *)page->owner;
> +			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
> +					PAGE_SHIFT);

If I understand correctly, this sends signal to the userspace hypervisor, i.e.
Qemu?  Can you elaborate how is KVM supposed to inject the #MC to guest, instead
of Qemu process (the VM) being killed?



-- 
Thanks,
-Kai


