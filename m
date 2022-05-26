Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8E7C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 26 May 2022 00:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbiEZAhJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 May 2022 20:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346503AbiEZAgp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 May 2022 20:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24B412A86
        for <linux-sgx@vger.kernel.org>; Wed, 25 May 2022 17:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DDD76167C
        for <linux-sgx@vger.kernel.org>; Thu, 26 May 2022 00:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD61C385B8;
        Thu, 26 May 2022 00:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653525404;
        bh=XEdRHXdDqm84t8drwIvUbNf6MHxkinW2vNaTaVpe408=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r7eONf6RBn/n4SRTWFiQ3LtLfZLO6T6zr9yWDdFdVgFpVqpL4h4t2vSamA2ZpilL/
         7SSOLW8sFbD1CzbkMizVmQjVzdJ6ZwE4882Wsf/TRRQBWMTMo4GGT/9WI3HseohQ4y
         P1cf7B1g2lzA+IIfN/1DwD65ydMdZZ/4hjtF5nxcL/2fAm0+WXjsDUhpc+6OCfytiY
         sTlrB+B/ph2hwDrV/sefgT2/MDuXPf+PaltldxdOP86iX0rT1TMJsFYQ3nsvUNf+Gh
         lTm1aN2b6tVHFdwlFAOAB/57um8ZRRN0/dfSZg1KKLl8BQGeVBerB9hAX3zUEmXKBP
         iyo2+jbtSzg2A==
Message-ID: <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com
Cc:     dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com
Date:   Thu, 26 May 2022 03:35:00 +0300
In-Reply-To: <20220525100604.760576-1-zhiquan1.li@intel.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2022-05-25 at 18:06 +0800, Zhiquan Li wrote:
> V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1e=
c@intel.com/T/#t
>=20
> Changes since V2:
> - Repurpose the owner field as the virtual address of virtual EPC page
> - Remove struct sgx_vepc_page and relevant code.
> - Remove patch 01 as the changes are not necessary in new design.
> - Rework patch 02 suggested by Jarkko.
> - Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
> - Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
> =C2=A0 SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
> =C2=A0 Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2=
816785@intel.com/T/#u
>=20
> V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de7=
6@intel.com/T/#t
>=20
> Changes since V1:
> - Updated cover letter and commit messages, added valuable
> =C2=A0 information from Jarkko, Tony and Kai's comments.
> - Added documentations for struct struct sgx_vepc and
> =C2=A0 struct sgx_vepc_page.
>=20
> Hi everyone,
>=20
> This series contains a few patches to fine grained SGX MCA behavior.
>=20
> When VM guest access a SGX EPC page with memory failure, current
> behavior will kill the guest, expected only kill the SGX application
> inside it.
>=20
> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> information for hypervisor to inject #MC information to guest, which
> is helpful in SGX virtualization case.
>=20
> The rest of things are guest side. Currently the hypervisor like
> Qemu already has mature facility to convert HVA to GPA and inject #MC
> to the guest OS.
>=20
> Then we extend the solution for the normal SGX case, so that the task
> has opportunity to make further decision while EPC page has memory
> failure.
>=20
> However, when a page triggers a machine check, it only reports the PFN.
> But in order to inject #MC into hypervisor, the virtual address
> is required. Then repurpose the "owner" field as the virtual address of
> the virtual EPC page so that arch_memory_failure() can easily retrieve
> it.
>=20
> The EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the meaning
> of the field.
>=20
> Suppose an enclave is shared by multiple processes, when an enclave
> page triggers a machine check, the enclave will be disabled so that
> it couldn't be entered again. Killing other processes with the same
> enclave mapped would perhaps be overkill, but they are going to find
> that the enclave is "dead" next time they try to use it. Thanks for
> Jarkko's head up and Tony's clarification on this point.
>=20
> Our intension is to provide additional info so that the application has
> more choices. Current behavior looks gently, and we don't want to
> change it.
>=20
> If you expect the other processes to be informed in such case, then
> you're looking for an MCA "early kill" feature which worth another
> patch set to implement it.
>=20
> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> VMs. It is because how enclaves are created is totally up to the guest.
> Sharing virtual EPC instance will be very likely to unexpectedly break
> enclaves in all VMs.
>=20
> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork(). However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.
>=20
> This series is based on tip/x86/sgx with the following additionally
> applied:
>=20
> "x86/sgx: Keep record for SGX VA and Guest page type"
> https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.=
com/T/#mbd2ca61983f1f9514a8baf07fdb17d33495eeada
>=20
> Tests:
> 1. MCE injection test for SGX in VM.
> =C2=A0=C2=A0 As we expected, the application was killed and VM was alive.
> 2. MCE injection test for SGX on host.
> =C2=A0=C2=A0 As we expected, the application received SIGBUS with extra i=
nfo.
> 3. Kernel selftest/sgx: PASS
> 4. Internal SGX stress test: PASS
> 5. kmemleak test: No memory leakage detected.
>=20
> Much appreciate your feedback.
>=20
> Best Regards,
> Zhiquan
>=20
> Zhiquan Li (3):
> =C2=A0 x86/sgx: Repurpose the owner field as the virtual address of virtu=
al
> =C2=A0=C2=A0=C2=A0 EPC page
> =C2=A0 x86/sgx: Fine grained SGX MCA behavior for virtualization
> =C2=A0 x86/sgx: Fine grained SGX MCA behavior for normal case
>=20
> =C2=A0arch/x86/kernel/cpu/sgx/main.c | 27 +++++++++++++++++++++++++--
> =C2=A0arch/x86/kernel/cpu/sgx/sgx.h=C2=A0 |=C2=A0 2 ++
> =C2=A0arch/x86/kernel/cpu/sgx/virt.c |=C2=A0 4 +++-
> =C2=A03 files changed, 30 insertions(+), 3 deletions(-)
>=20

This applies on top of Cathy's series, right? Why not send one
series with all 12 patches included?

It makes reviewing easier, and we are well beyond 5.19 timeline
for these features.

BR, Jarkko
