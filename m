Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADF5C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 17:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7515A64F30
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 17:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhCRRkm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:40:42 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50794 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231952AbhCRRkf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Mar 2021 13:40:35 -0400
Received: from zn.tnic (p200300ec2f0fad00070f6d4b275c681b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:ad00:70f:6d4b:275c:681b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 077CB1EC0249;
        Thu, 18 Mar 2021 18:40:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616089234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5HUi4f5dejF+zrDWqEx6xSCL/wddRn6cotJCPEsJDjc=;
        b=MnvJO+hRdyGGJWjcUH7ef8qvOmnp5N7CkLRWm0fMaAj8AEYXcaQ8YG1YUHanwbMTi8nrEF
        uJvBuzpW2Ccg6pZrGTvGB29D6zr08TifaTfPtWOKDJ/wPVFHSby1WBb0EzvvpjRk5yrFE/
        fPikY0QsWlSvh8qW45Yavi4Sx4wzs4g=
Date:   Thu, 18 Mar 2021 18:40:32 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sgx: Replace section->init_laundry_list with
 sgx_dirty_page_list
Message-ID: <20210318174032.GI19570@zn.tnic>
References: <20210317235332.362001-1-jarkko.sakkinen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210317235332.362001-1-jarkko.sakkinen@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 18, 2021 at 01:53:30AM +0200, Jarkko Sakkinen wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> During normal runtime, the "ksgxd" daemon behaves like a  version of
> kswapd just for SGX.  But, before it starts acting like kswapd, its
> first job is to initialize enclave memory.
> 
> Currently, the SGX boot code places each enclave page on a
> epc_section->init_laundry_list.  Once it starts up, the ksgxd code walks
> over that list and populates the actual SGX page allocator.
> 
> However, the per-section structures are going away to make way for the SGX
> NUMA allocator.  There's also little need to have a per-section structure;
> the enclave pages are all treated identically, and they can be placed on
> the correct allocator list from metadata stored in the enclave page
> (struct sgx_epc_page) itself.
> 
> Modify sgx_sanitize_section() to take a single page list instead of taking
> a section and deriving the list from there.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
> v5
> * Refine the commit message.
> * Refine inline comments.
> * Encapsulate a sanitization pass into __sgx_sanitize_pages().
> 
> v4:
> * Open coded sgx_santize_section() to ksgxd().
> * Rewrote the commit message.
> 
>  arch/x86/kernel/cpu/sgx/main.c | 54 ++++++++++++++++------------------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  7 -----
>  2 files changed, 25 insertions(+), 36 deletions(-)

So both patches look ok to me but the sgx test case fails on -rc3 with and
without those patches on my box:

./test_sgx 
0x0000000000000000 0x0000000000002000 0x03
0x0000000000002000 0x0000000000001000 0x05
0x0000000000003000 0x0000000000003000 0x03
mmap() failed, errno=1.

Box is:

[    0.138402] smpboot: CPU0: Intel(R) Core(TM) i5-9600K CPU @ 3.70GHz (family: 0x6, model: 0x9e, stepping: 0xc)
[    0.693947] sgx: EPC section 0x80200000-0x85ffffff

And AFAIR that test used to pass there...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
