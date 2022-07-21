Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B394FC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jul 2022 16:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGUQym (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Jul 2022 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiGUQyl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Jul 2022 12:54:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CCB8BAA5
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jul 2022 09:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658422480; x=1689958480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lis43QEvOKA87q+oCCSLAZdaBp852Fv+CO3NsxEhEmk=;
  b=WTwV0tp6KZRwtQ4N+HQ2AIttevmKmnwFcAHqKefWSm/2mtWCvNn4p92q
   iFyqCdIPkNeDJpISAVJVyIyv8bRqA04aDR46Gkm43NIOPl0OS+6ftCc/F
   wpIF51uwDn6j6WOas9cCtxnUD8auW5dwia7MGc5CvHdPOFUTqA4RD7nX1
   //ltvA1x0YiXCEcQ+hiEIqETvfj/FvmU/wWLwZvWOj5rrPJJbCAeWAPOY
   xIGVUZr+1YXHOj+2JyqZvnmbQMFiNjRlQk+//HPmFzvDQXf3hiSyri47B
   jXoLxCHFOeXx400l8UntL1LWgiG+PiJIBhONMiJ2K6fr1//10dzcGiZ9O
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287857220"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="287857220"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:54:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="573817785"
Received: from vasantgx-mobl.amr.corp.intel.com (HELO [10.212.244.191]) ([10.212.244.191])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:54:39 -0700
Message-ID: <32429523-3a71-2743-02b4-ea6ad1d99002@intel.com>
Date:   Thu, 21 Jul 2022 09:54:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 2/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
 <20220622093705.2891642-3-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220622093705.2891642-3-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/22/22 02:37, Zhiquan Li wrote:
> When VM guest access a SGX EPC page with memory failure, current
> behavior will kill the guest, expected only kill the SGX application
> inside it.

Can we please clean this up?  This is generally readable, but _hard_ to
read.  Perhaps:

	Today, if a guest accesses an SGX EPC page with memory failure,
	the kernel will behavior will kill the entire guest.  This blast
	radius is too large.  It would be idea to kill only the SGX
	application inside the guest.

> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra

	    ^ No "we's".

> information for hypervisor to inject #MC information to guest, which is
> helpful in SGX case.

To fix this, send a SIGBUS to host userspace (like QEMU) which can
follow up by injecting a #MC to the guest.

> The rest of things are guest side. Currently the hypervisor like Qemu
> already has mature facility to convert HVA to GPA and inject #MC to
> the guest OS.
> 
> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> VMs.  It is because how enclaves are created is totally up to the guest.
> Sharing virtual EPC instance will be very likely to unexpectedly break
> enclaves in all VMs.

I'm not sure why this is here or why it is important to this patch.

> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork().  However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.


> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index ab4ec54bbdd9..4507c2302348 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
>  	struct sgx_epc_section *section;
>  	struct sgx_numa_node *node;
> +	unsigned long vaddr;
> +	int ret;
>  
>  	/*
>  	 * mm/memory-failure.c calls this routine for all errors
> @@ -731,8 +733,26 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	 * error. The signal may help the task understand why the
>  	 * enclave is broken.
>  	 */
> -	if (flags & MF_ACTION_REQUIRED)
> -		force_sig(SIGBUS);
> +	if (flags & MF_ACTION_REQUIRED) {
> +		/*
> +		 * Provide extra info to the task so that it can make further
> +		 * decision but not simply kill it. This is quite useful for
> +		 * virtualization case.
> +		 */
> +		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
> +			/*
> +			 * The "owner" field is repurposed as the virtual address
> +			 * of virtual EPC page.
> +			 */
> +			vaddr = (unsigned long)page->owner & PAGE_MASK;

I really don't like repurposing page->owner like this.  It requires
casting on *both* sides of a type that we have full control over.

	struct sgx_epc_page {
	        unsigned int section;
	        u16 flags;
	        u16 poison;
		union {
		        struct sgx_encl_page *encl_owner;
			// Use when SGX_EPC_PAGE_KVM_GUEST
			// set in ->flags:
		        void __user *vepc_vaddr;
		};
	        struct list_head list;
	};

There is zero reason to play casting games instead of doing that ^

> +			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)vaddr,
> +					PAGE_SHIFT);
> +			if (ret < 0)
> +				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
> +					current->comm, current->pid, ret);
> +		} else
> +			force_sig(SIGBUS);
> +	}


