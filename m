Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC67ECAAD2
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Sep 2022 22:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiIAWbI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiIAWan (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Sep 2022 18:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44D6D9D
        for <linux-sgx@vger.kernel.org>; Thu,  1 Sep 2022 15:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49976B8293B
        for <linux-sgx@vger.kernel.org>; Thu,  1 Sep 2022 22:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1167C433D6;
        Thu,  1 Sep 2022 22:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662071370;
        bh=KQj3iNyASUtYcqldylh3JNvPEm1DfPVEBwQbarRbuKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4lIGqxpeAoh4w4ueucM8f26KxEWnPwnxrTmhYeP8Ce7kSpWnA2mKer1yPhvJ6CFx
         VRwnuvAJIx710JX1RzgxOpK/QWfcikge1tTVB0E0ya9Ux2rN3TlZ4TuPo7qGPQ68AX
         LOcadrVbvrQjDUeAhYKTIlS5wMLJFzZl34SyJfWSgxHr4+ye+wSttiNG3EAAW/UIM7
         4EmwLNZunqBmwZnRzffPcqrllxXMHsCc44YdZXixIZvRg8HIBKEwiS6EapMPjJr/3g
         WNJZGWMBulurC6S8upQlzyh9mQsHZblRP4r9uaQZBi0iXBnNiGsuj79L/D4NxMl9Ak
         v5VE125Gby9yA==
Date:   Fri, 2 Sep 2022 01:29:25 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH v7 0/3] x86/sgx: fine grained SGX MCA behavior
Message-ID: <YxEyRT2SbfBdYNfm@kernel.org>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220901003601.2048563-1-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 01, 2022 at 08:35:58AM +0800, Zhiquan Li wrote:
> V6: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V6:
> - Revise the commit message of patch 01 suggested by Jarkko.
> - Fix build warning due to type changes.
> 
> V5: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#t
> 
> Changes since V5:
> - Rename the 'owner' field as 'encl_owner' and update the references
>   as a separate patch.
> - To prevent casting the 'encl_owner' field, introduce a union with
>   another field - "vepc_vaddr", suggested by Dave Hansen.
> - Clean up the commit message of patch 02 suggested by Dave Hansen.
> - Remove patch 03 unless we have better reason to keep it.
> - Add Reviewed-by from Jarkko.
> 
> V4: https://lore.kernel.org/linux-sgx/20220608032654.1764936-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V4:
> - Switch the order of the two variables at patch 02 so all of variables
>   are in reverse Christmas style.
> - Do not initialize 'ret' because it will be overridden by the return
>   value of force_sig_mceerr() unconditionally.
> - Add Co-developed-by and Signed-off-by from Cathy Zhang at patch 01.
> - Add Acked-by from Kai Huang at patch 01.
> 
> V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t
> 
> Changes since V3:
> - Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy Zhang's third patch of SGX rebootless recovery patch set but
>   discard irrelevant portion, since it might need some time to re-forge
>   and these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t
> 
> Changes since V2:
> - Repurpose the owner field as the virtual address of virtual EPC page
> - Remove struct sgx_vepc_page and relevant code.
> - Remove patch 01 as the changes are not necessary in new design.
> - Rework patch 02 suggested by Jarkko.
> - Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
> - Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
>   SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t
> 
> Changes since V1:
> - Updated cover letter and commit messages, added valuable
>   information from Jarkko, Tony and Kai's comments.
> - Added documentations for struct struct sgx_vepc and
>   struct sgx_vepc_page.
> 
> Hi everyone,
> 
> This series contains a few patches to fine grained SGX MCA behavior.
> 
> Today, if a guest accesses an SGX EPC page with memory failure,
> the kernel behavior will kill the entire guest.  This blast radius is
> too large.  It would be idea to kill only the SGX application inside
> the guest.
> 
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.
> 
> However, when a page triggers a machine check, it only reports the
> PFN.  But in order to inject #MC into hypervisor, the virtual address
> is required.  The 'encl_owner' field is useless in virtualization
> case, then repurpose it as 'vepc_vaddr' - the virtual address of the
> virtual EPC page for such case so that arch_memory_failure() can easily
> retrieve it.
> 
> Suppose an enclave is shared by multiple processes, when an enclave
> page triggers a machine check, the enclave will be disabled so that
> it couldn't be entered again.  Killing other processes with the same
> enclave mapped would perhaps be overkill, but they are going to find
> that the enclave is "dead" next time they try to use it.  Thanks for
> Jarkko’s head up and Tony’s clarification on this point.
> 
> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> VMs. It is because how enclaves are created is totally up to the guest.
> Sharing virtual EPC instance will be very likely to unexpectedly break
> enclaves in all VMs.
> 
> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork(). However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.
> 
> This series is based on tip/x86/sgx.
> 
> Tests:
> 1. MCE injection test for SGX in VM.
>    As we expected, the application was killed and VM was alive.
> 2. Kernel selftest/sgx: PASS
> 3. Internal SGX stress test: PASS
> 4. kmemleak test: No memory leakage detected.
> 
> Much appreciate your feedback.
> 
> Best Regards,
> Zhiquan
> 
> Zhiquan Li (3):
>   x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
>   x86/sgx: Introduce union with vepc_vaddr field for virtualization case
>   x86/sgx: Fine grained SGX MCA behavior for virtualization
> 
>  arch/x86/kernel/cpu/sgx/main.c | 48 +++++++++++++++++++++++++---------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  8 +++++-
>  arch/x86/kernel/cpu/sgx/virt.c |  4 ++-
>  3 files changed, 46 insertions(+), 14 deletions(-)
> 
> -- 
> 2.25.1
> 


Acked-by: Jarkko Sakkinen <jarkko@kernel.org> (all patches)

BR, Jarkko
