Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA74C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 09:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiFHJrz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiFHJre (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 05:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6DB43AD4
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 02:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 391C8B8261A
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 09:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD16C3411C;
        Wed,  8 Jun 2022 09:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654679653;
        bh=JHzxisSAcengTQkGQO1zPaWX8IOEeNCXNElWfRkjCoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qc2j6BFHx2tLfNqFKlYtiCo/dQFbFdklHeFMl9kHEcU+AxaJKJ+6H8fDeRm3EiLy0
         CS04EWTMbeetG1KkzMsnlied4o7YJryQWQj51ZRXx/Dy7Vnd41YryrL1823QqrgGpO
         FK7ACFVLSgT2o1v8uLZSLZMxSZSyUQ+KVgmMfO4juNdzSL0s/d242gDmGY8m+dy3Sj
         CZ+hm+lkXK68rydhlDi5aAuosz+ZZDAEyXzJOezS77DJJXjrzBTAFbQiSlIKooNBNc
         ix3NaPEFtt8xqGJUHBiphGi41iKeI8TQrbxyiqu30SZUndWlfKWjVebH4shBq2+brq
         cmeqz8vPun1hw==
Date:   Wed, 8 Jun 2022 12:12:17 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, cathy.zhang@intel.com
Subject: Re: [PATCH v4 0/3] x86/sgx: fine grained SGX MCA behavior
Message-ID: <YqBn8SAsCFRKxeQz@iki.fi>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
 <YqBZbyWW4jTkn7qH@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YqBZbyWW4jTkn7qH@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 08, 2022 at 11:10:23AM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 08, 2022 at 11:26:51AM +0800, Zhiquan Li wrote:
> > V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t
> > 
> > Changes since V3:
> > - Move the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
> >   Cathy's third patch of SGX rebootless recovery patch set but discard
> >   irrelevant portion, since it might need more time to re-forge and
> >   these are two different features.
> >   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> > 
> > V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t
> > 
> > Changes since V2:
> > - Repurpose the owner field as the virtual address of virtual EPC page
> > - Remove struct sgx_vepc_page and relevant code.
> > - Remove patch 01 as the changes are not necessary in new design.
> > - Rework patch 02 suggested by Jarkko.
> > - Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
> > - Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
> >   SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
> >   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> > 
> > V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t
> > 
> > Changes since V1:
> > - Updated cover letter and commit messages, added valuable
> >   information from Jarkko, Tony and Kai’s comments.
> > - Added documentations for struct struct sgx_vepc and
> >   struct sgx_vepc_page.
> > 
> > Hi everyone,
> > 
> > This series contains a few patches to fine grained SGX MCA behavior.
> > 
> > When VM guest access a SGX EPC page with memory failure, current
> > behavior will kill the guest, expected only kill the SGX application
> > inside it.
> > 
> > To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> > information for hypervisor to inject #MC information to guest, which
> > is helpful in SGX virtualization case.
> > 
> > The rest of things are guest side. Currently the hypervisor like
> > Qemu already has mature facility to convert HVA to GPA and inject #MC
> > to the guest OS.
> > 
> > Then we extend the solution for the normal SGX case, so that the task
> > has opportunity to make further decision while EPC page has memory
> > failure.
> > 
> > However, when a page triggers a machine check, it only reports the PFN.
> > But in order to inject #MC into hypervisor, the virtual address
> > is required. Then repurpose the “owner” field as the virtual address of
> > the virtual EPC page so that arch_memory_failure() can easily retrieve
> > it.
> > 
> > Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
> > meaning of the field.
> > 
> > Suppose an enclave is shared by multiple processes, when an enclave
> > page triggers a machine check, the enclave will be disabled so that
> > it couldn't be entered again. Killing other processes with the same
> > enclave mapped would perhaps be overkill, but they are going to find
> > that the enclave is "dead" next time they try to use it. Thanks for
> > Jarkko’s head up and Tony’s clarification on this point.
> > 
> > Our intension is to provide additional info so that the application has
> > more choices. Current behavior looks gently, and we don’t want to
> > change it.
> > 
> > If you expect the other processes to be informed in such case, then
> > you’re looking for an MCA “early kill” feature which worth another
> > patch set to implement it.
> > 
> > Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> > VMs. It is because how enclaves are created is totally up to the guest.
> > Sharing virtual EPC instance will be very likely to unexpectedly break
> > enclaves in all VMs.
> > 
> > SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> > being shared by multiple VMs via fork(). However KVM doesn't support
> > running a VM across multiple mm structures, and the de facto userspace
> > hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> > this should not happen.
> > 
> > This series is based on tip/x86/sgx.
> > 
> > Tests:
> > 1. MCE injection test for SGX in VM.
> >    As we expected, the application was killed and VM was alive.
> > 2. MCE injection test for SGX on host.
> >    As we expected, the application received SIGBUS with extra info.
> > 3. Kernel selftest/sgx: PASS
> > 4. Internal SGX stress test: PASS
> > 5. kmemleak test: No memory leakage detected.
> > 
> > Much appreciate your feedback.
> > 
> > Best Regards,
> > Zhiquan
> > 
> > Zhiquan Li (3):
> >   x86/sgx: Repurpose the owner field as the virtual address of virtual
> >     EPC page
> >   x86/sgx: Fine grained SGX MCA behavior for virtualization
> >   x86/sgx: Fine grained SGX MCA behavior for normal case
> > 
> >  arch/x86/kernel/cpu/sgx/main.c | 27 +++++++++++++++++++++++++--
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
> >  arch/x86/kernel/cpu/sgx/virt.c |  4 +++-
> >  3 files changed, 30 insertions(+), 3 deletions(-)
> > 
> > -- 
> > 2.25.1
> > 
> 
> LGTM, I'll have to check if I'm able to trigger MCE with
> /sys/devices/system/memory/hard_offline_page, as hinted by Tony.
> 
> Just trying to think how to get a legit PFN number. I guess one workable
> way is to attach kretprobe to sgx_alloc_epc_page(), and do similar
> conversion as in sgx_get_epc_phys_addr() for ((struct sgx_epc_page
> *)retval) and print it out.

Or I just lookup the address range with dmesg, and then loop through
the PFN's writing them one by one until the enclave dies.

BR, Jarkko
