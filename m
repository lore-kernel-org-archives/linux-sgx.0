Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E9BC48BC2
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Jun 2021 13:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA75B6113B
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Jun 2021 13:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhFWNet (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhFWNej (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Jun 2021 09:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD1561076;
        Wed, 23 Jun 2021 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624455141;
        bh=Tfy4Kcl1G/62IHsG83uwh+nanQpJpW+dZHtJIAsstRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaC5aBQGG9oOd0TrvI+dVAmmjAlInqOJnfdrBcfrhVFc8HQL7MvQqQpeWCWDkgkEj
         Zkg5806GK0IJU0VDsc2iY2Yd1F/aSQQfwB03j8ca2P7AevQR4nY++R+5eBy4ZjdmVZ
         8GUVtWy1tTv5w5rAqmQ9RyNWQDXtmzyXMoc2GtQ0jmu0IUqlkvwni8ZWTJoqyZf4oZ
         cU1MEDNpUeWjsqoaExkMcNFI6ztE0sp1pfbAvVcbfbFOIXTl7yk3A+BqfXo2ZApsR0
         yvcAOfB5UWQGhWlD5+cSZ3w4Qb+pZZSamsIYQWzxgDcvuJ2oXXLTOB2HUg6hK2X588
         edtostLAVEdMw==
Date:   Wed, 23 Jun 2021 16:32:19 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Suppress WARN on inability to sanitize EPC if
 ksgxd is stopped
Message-ID: <20210623133219.v6c62zwtj5qowib3@kernel.org>
References: <20210616004458.2192889-1-seanjc@google.com>
 <YMmUHRGwXSIYJTDf@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YMmUHRGwXSIYJTDf@nuc>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 16, 2021 at 02:03:09PM +0800, Du Cheng wrote:
> Le Tue, Jun 15, 2021 at 05:44:58PM -0700, Sean Christopherson a écrit :
> > Don't WARN on having unsanitized EPC pages if ksgxd is stopped early,
> > e.g. if sgx_init() realizes there will be no downstream consumers of EPC.
> > If ksgxd is stopped early, EPC pages may be left on the dirty list, but
> > that's ok because ksgxd is only stopped if SGX initialization failed or
> > if the kernel is going down.  In either case, the EPC won't be used.
> > 
> > This bug was exposed by the addition of KVM support, but has existed and
> > was hittable since the original sanitization code was added.  Prior to
> > adding KVM support, if Launch Control was not fully enabled, e.g. when
> > running on older hardware, sgx_init() bailed immediately before spawning
> > ksgxd because X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was
> > unsupported.
> > 
> > With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check
> > manually, so now there's any easy-to-hit case where sgx_init() will spawn
> > ksgxd and _then_ fail to initialize, which results in sgx_init() stopping
> > ksgxd before it finishes sanitizing the EPC.
> > 
> > Prior to KVM support, the bug was much harder to hit because it basically
> > required char device registration to fail.
> > 
> > Reported-by: Du Cheng <ducheng2@gmail.com>
> > Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Lightly tested due to lack of hardware.  I hacked the flow to verify that
> > stopping early will leave work pending, and that rechecking should_stop()
> > suppress the resulting WARN.
> > 
> >  arch/x86/kernel/cpu/sgx/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index ad904747419e..fbad2b9625a5 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -425,7 +425,7 @@ static int ksgxd(void *p)
> >  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> >  
> >  	/* sanity check: */
> > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > +	WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());
> >  
> >  	while (!kthread_should_stop()) {
> >  		if (try_to_freeze())
> > -- 
> > 2.32.0.272.g935e593368-goog
> > 
> 
> I applied this patch on 5.13-rc6, and it no longer causes to trigger WARN_ON()
> on my NUC:
> 
> ```
> 
> [    0.669411] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.669412] software IO TLB: mapped [mem 0x0000000017cb9000-0x000000001bcb9000] (64MB)
> [    0.672788] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.672805] sgx: EPC section 0x30200000-0x35f7ffff
> [    0.674239] Initialise system trusted keyrings
> [    0.674254] Key type blacklist registered
> 
> ```
> 
> Regards,
> Du Cheng

Can you thus give a tested-by for this?

/Jarkko
