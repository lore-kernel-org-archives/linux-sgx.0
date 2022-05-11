Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD83C433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiEKKbg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiEKKbd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:31:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8C33BF8E
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C90B821F4
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9CCC340ED;
        Wed, 11 May 2022 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652265087;
        bh=GZnaGfYGxfeCWICnnqXs99zF/yuCIsqKCi7SI0aBtmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MkEkDP4KK4lh//9dFHFmBtAsG8NRi4+uewWP+XvlbZTyZlQxc6MZ03Y508chgqHt0
         Q6bKRPOgjdzbqH1e/KMtxPK2UHAchi5+gfcFix0vjbQDMOFhy0UIvec7PrwMFy7omP
         W0guNSalkYf5mLFZZ+PFxMJ70DJKLmEb9uWiaBAM7rs2EriDYhYAp1anzIqGXsFUj3
         PLYYkoTKciZoMVodflLS73B6betjhGuuAqNeC9qbojiKMTBw0aOv7SPMIZTrU4RjVF
         +fbSDBswc9otzTe0GRZgdzGro0yubIo+uJVKff02Xc0dautj6ZQkOWqwMR2nZ9/AJR
         odesoKiQ/JrlQ==
Date:   Wed, 11 May 2022 13:29:57 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com, fan.du@intel.com
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Message-ID: <YnuQJaM0p7gD5qel@kernel.org>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510031646.3181306-1-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 10, 2022 at 11:16:46AM +0800, Zhiquan Li wrote:
> Hi everyone,
> 
> This series contains a few patches to fine grained SGX MCA behavior.
> 
> When VM guest access a SGX EPC page with memory failure, current
> behavior will kill the guest, expected only kill the SGX application
> inside it.
> 
> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> information for hypervisor to inject #MC information to guest, which
> is helpful in SGX virtualization case.
> 
> However, current SGX data structures are insufficient to track the
> EPC pages for vepc, so we introduce a new struct sgx_vepc_page which
> can be the owner of EPC pages for vepc and saves the useful info of
> EPC pages for vepc, like struct sgx_encl_page.
> 
> Moreover, canonical memory failure collects victim tasks by iterating
> all the tasks one by one and use reverse mapping to get victim tasks’
> virtual address. This is not necessary for SGX - as one EPC page can
> be mapped to ONE enclave only. So, this 1:1 mapping enforcement
> allows us to find task virtual address with physical address
> directly.

Hmm... An enclave can be shared by multiple processes. The virtual
address is the same but there can be variable number of processes
having it mapped.

> 
> Then we extend the solution for the normal SGX case, so that the task
> has opportunity to make further decision while EPC page has memory
> failure.
> 
> Tests:
> 1. MCE injection test for SGX in VM.
>    As we expected, the application was killed and VM was alive.
> 2. MCE injection test for SGX on host.
>    As we expected, the application received SIGBUS with extra info.
> 3. Kernel selftest/sgx: PASS
> 4. Internal SGX stress test: PASS
> 5. kmemleak test: No memory leakage detected.
> 
> Zhiquan Li (4):
>   x86/sgx: Move struct sgx_vepc definition to sgx.h
>   x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
>   x86/sgx: Fine grained SGX MCA behavior for virtualization
>   x86/sgx: Fine grained SGX MCA behavior for normal case
> 
>  arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
>  arch/x86/kernel/cpu/sgx/sgx.h  | 12 ++++++++++++
>  arch/x86/kernel/cpu/sgx/virt.c | 29 +++++++++++++++++++----------
>  3 files changed, 53 insertions(+), 12 deletions(-)
> 
> -- 
> 2.25.1
> 

BR, Jarkko
