Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D439C48BCF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 12:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48434613B8
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 12:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhFIM7n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jun 2021 08:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhFIM7m (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jun 2021 08:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68728613AD;
        Wed,  9 Jun 2021 12:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623243467;
        bh=GwT/hXOsCoDh1QvTYkVaS3wCFQbHRSV7IYtCPVmTmYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kt4nDU2QAsUBomb4rzDYAxE8n9zBfAnxUtEYnuHLCHEyWNlZ8KyI6lH0XD4S3oEzj
         FUhJO0Yq7jvU3Di/UudK55gpecA70lmn0fZiihb/Ds4akYOUSOuZZEcds1VBex66nn
         KJ3Yi6augtkueegm8A9ECYwIMagX/qGtHsiUYGBIuYstgiZMjNXyjpr6hlBC+DiR/E
         Tu3j7f6eeufk1bb2oZaYxDsFhMPOhT3j7sSsfTtit3KuWP4dTMwLGwbxdaQldqurv4
         Np50UdrPsncI4jdhF6vqaUbcmpDpRg9qZnLAEGXFsGlg0zNaDIb/jxOPwa3D8+ROi+
         6KZjJt9q6o3og==
Date:   Wed, 9 Jun 2021 15:57:45 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Du Cheng <ducheng2@gmail.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, dave.hansen@intel.com
Subject: Re: [BUG] bug report on x86/sgx: ksgxd()
Message-ID: <20210609125745.risptjqckh4kh3d5@kernel.org>
References: <YLb8y5YMFAsRKJMg@nuc>
 <20210603065745.v3iupi3k3oxea424@kernel.org>
 <YLlLsJQAQ5uQk+hf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLlLsJQAQ5uQk+hf@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 03, 2021 at 09:37:52PM +0000, Sean Christopherson wrote:
> On Thu, Jun 03, 2021, Jarkko Sakkinen wrote:
> > On Wed, Jun 02, 2021 at 11:36:43AM +0800, Du Cheng wrote:
> > > Hi,
> > > 
> > > I like to report a bug on my linux box running the mainline linux of version:
> > > commit 8124c8a6b35386f73523d27eacb71b5364a68c4c tag: v5.13-rc4
> > > 
> > > After it boots on my intel NUC, I encounter this error in the console log, I
> > > believe it is triggered by a WARN_ON():
> > > 
> > > [    0.628094] sgx: EPC section 0x30200000-0x35f7ffff
> > > [    0.628503] ------------[ cut here ]------------
> > > [    0.628506] WARNING: CPU: 6 PID: 127 at arch/x86/kernel/cpu/sgx/main.c:428 ksgxd+0x1c8/0x1e0
> > > 
> > > 
> > > I have attached my config file with which I compiled the kernel, just in case it is helpful.
> > > 
> > > I am running on ubuntu 21.04 with mainline kernel, and my box is intel NUC:
> > > 
> > > 	Product Name: NUC10i5FNH
> > > 	SKU Number: BXNUC10i5FNH
> > > 	Product Name: NUC10i5FNB
> > 
> > Is it possible to test with 5.12?
> > 
> > Linux does not support that hardware, except for KVM VM's, which was
> > added in 5.13.
> 
> I'm pretty sure that the issue is kthread_stop() being called on ksgxd before
> __sgx_sanitize_pages() completes, and that lack of launch control is what is
> exposing the bug.
> 
> Prior to adding KVM support, sgx_init() bailed immediately because
> X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was unsupported.
> 
> With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check manually,
> so now there's any easy-to-hit case where sgx_init() will spawn ksgxd and _then_
> fails to initialize, which results in sgx_init() stopping ksgxd before it finishes
> sanitizing the EPC.
> 
> The bug existed before KVM support, it was just much harder to hit because it
> basically required char device registration to fail.
> 
> This should suppress the WARN if ksgxd is stopped early.
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 63d3de02bbcc..bdf31ddfb10d 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -425,7 +425,7 @@ static int ksgxd(void *p)
>         __sgx_sanitize_pages(&sgx_dirty_page_list);
> 
>         /* sanity check: */
> -       WARN_ON(!list_empty(&sgx_dirty_page_list));
> +       WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());
> 
>         while (!kthread_should_stop()) {
>                 if (try_to_freeze())
> 
> 
> If that works, then
> 
>   Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> 
> is probably most appropriate.

Since this could happen theoretically in 5.11, I agree that it's the
commit.

Can you send a proper patch? I can also mangle a patch, if you don't have
the bandwidth.

What you wrote above goes for a commit message.

/Jarkko
