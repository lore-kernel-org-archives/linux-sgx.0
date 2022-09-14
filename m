Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198F2C6FA82
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Sep 2022 15:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiINPqZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiINPqY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 14 Sep 2022 11:46:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E39D270C
        for <linux-sgx@vger.kernel.org>; Wed, 14 Sep 2022 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663170383; x=1694706383;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=5q7Lata1AlrnMorTzcoBuTqzSsws7pkMctr9+HLMcAw=;
  b=UO1rUcwX6ePnVDYbH8QYDDuEj1S91LAhA8lwGm107RXmWjNPkHxsJrXb
   yarTRW3AGk4GTpfK0jPLRPYtrsfKBipyUhwYjKOIbzPAv8WCh1wRgdeMU
   SEzqqYYyJISESyQes82QgrQFPaLCEc0aKQlrDOfMmkNGAauocf1npwAPZ
   qHFUibce0y0Z83u8vypj3uFamd3ZNSQsCyfGiAvARXFMDuTNePCgEhGKW
   Ko8yQgaRdGjQt86FekbUdJStn939n/BMiLMKSuhuFUMmAYgttFDtQPKPc
   zg3lWgMA8wHylhuU9WsVViadP9BIg2FaaWwJiIHZ1zmB+BVTj9ruE03ui
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="285502436"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="285502436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 08:46:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="619353815"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.212.25.253])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Sep 2022 08:46:21 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        "Zhiquan Li" <zhiquan1.li@intel.com>
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-3-zhiquan1.li@intel.com>
Date:   Wed, 14 Sep 2022 10:46:17 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1shsrfrrwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <20220913145330.2998212-3-zhiquan1.li@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Zhiquan

On Tue, 13 Sep 2022 09:53:29 -0500, Zhiquan Li <zhiquan1.li@intel.com>  
wrote:

> When a page triggers a machine check, it only reports the PFN.  But in
> order to inject #MC into hypervisor, the virtual address is required.
> The 'encl_owner' field is useless in virtualization case, then
> repurpose it as 'vepc_vaddr' - the virtual address of the virtual EPC
> page for such case so that arch_memory_failure() can easily retrieve it.
>
> Introduce a union to prevent adding a new dedicated structure to
> track the virtual address of virtual EPC page.  And it can also prevent
> playing the casting games while using it.
>
> Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
> meaning of the field.
>
> Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> ---
> Changes since V7:
> - Add Acked-by from Jarkko.
>
> No changes since V6.
>
> Changes since V5:
> - To prevent casting the 'encl_owner' field, introduce a union with
>   another field - 'vepc_vaddr', sugguested by Dave Hansen.
> - Add Reviewed-by from Jarkko.
>   Link:  
> https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1
>
> Changes since V4:
> - Add Co-developed-by and Signed-off-by from Cathy Zhang, as she had
>   fully discussed the flag name with Jarkko.
>   Link:  
> https://lore.kernel.org/all/df92395ade424401ac3c6322de568720@intel.com/
> - Add Acked-by from Kai Huang
>   Link:  
> https://lore.kernel.org/linux-sgx/0676cd4e-d94b-e904-81ae-ca1c05d37070@intel.com/T/#mccfb11df30698dbd060f2b6f06383cda7f154ef3
>
> Changes since V3:
> - Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy Zhang's third patch of SGX rebootless recovery patch set but
>   discard irrelevant portion, since it might need some time to
>   re-forge and these are two different features.
>   Link:  
> https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
>
> Changes since V2:
> - Remove struct sgx_vepc_page and relevant code.
> - Rework the patch suggested by Jarkko.
> - Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
>   duplicated to SGX_EPC_PAGE_KVM_GUEST.
>   Link:  
> https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
>
> Changes since V1:
> - Add documentation suggested by Jarkko.
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 4 ++++
>  arch/x86/kernel/cpu/sgx/sgx.h  | 8 +++++++-
>  arch/x86/kernel/cpu/sgx/virt.c | 4 +++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c  
> b/arch/x86/kernel/cpu/sgx/main.c
> index 1315c69a733e..b319bedcaf1e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -549,6 +549,10 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page  
> *page)
>   * Finally, wake up ksgxd when the number of pages goes below the  
> watermark
>   * before returning back to the caller.
>   *
> + * When an EPC page is assigned to KVM guest, repurpose the  
> 'encl_owner' field
> + * as the virtual address of virtual EPC page, since it is useless in  
> such
> + * scenario, so 'owner' is assigned to 'vepc_vaddr'.
> + *
>   * Return:
>   *   an EPC page,
>   *   -errno on error
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h  
> b/arch/x86/kernel/cpu/sgx/sgx.h
> index 4d88abccd12e..d16a8baa28d4 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,12 +28,18 @@
> /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* Pages allocated for KVM guest */
> +#define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
> struct sgx_epc_page {
>  	unsigned int section;
>  	u16 flags;
>  	u16 poison;
> -	struct sgx_encl_page *encl_owner;
> +	union {
> +		struct sgx_encl_page *encl_owner;
> +		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
> +		void __user *vepc_vaddr;
> +	};

Maybe it's just me missing some prior knowledge. It's not obvious to me  
why you don't need any guard accessing the encl_owner field in ksgxd  
thread. Is it because all vepc pages are never put in the active list and  
encl_owner would never be null for all pages in that list?
Regardless, could you add a few sentence here to to make the rule explicit?

Thanks
Haitao
