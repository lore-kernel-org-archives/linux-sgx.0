Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9114AC49EA6
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 00:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C51B613BD
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 00:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhFYAt4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Jun 2021 20:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYAt4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 24 Jun 2021 20:49:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4115C061574;
        Thu, 24 Jun 2021 17:47:35 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q192so6661342pfc.7;
        Thu, 24 Jun 2021 17:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8B//zImoFREh/Fl/sfCs/fTYt5LIydvNJamavm5crDo=;
        b=fChoQ8YOJIJWOvywMQFN+OeVkjRs1GAQiSUaVGPXAWzbGNwgVtGIArBYmVPF2iMANZ
         Kjb+jS4jhh7fg/kTNhHUcyj4cdqijHKYmipL0Ez2/sNyzDluX6qcpQfbVzZX46wSEKe6
         WB1qzEFHdeqEczVjSvGI35HHNdI9uwIXTewNcuFVR/FQAfm/BXBdmnycKRrdZfOVXYzb
         4JtBEh1QzIziVqij7djz98e6E4xEM3MrQuRphCKQS4LgI9cm+94rVGQvSqryFG7XxHpG
         zW9V6LaeuukLBn5oCTGz0LGOqzbR8pXpZgpeTNR6WV7GBpMyga1bLSGGrfRcCIlNZlWJ
         dRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8B//zImoFREh/Fl/sfCs/fTYt5LIydvNJamavm5crDo=;
        b=jglx1dvgGPH1deuK8/dx9TeA4ZaZqQu8SBjFoR+xE02hRytKfLbthUEfLodD8B1jLI
         dcSv+8+tP3KBhZmqWPeBsDvP3vOKqgviLLTBP0QUhonSxefmlL/TnufxcpSoiNEJgcJE
         GVeFjhge+MxBD7XWHqWsKBekcgspitVfcSlPtHspWCXjLxTDZDjJ3jxRLR+Zu6iUDJBm
         SKGK4cYWh0mb0l5oOydyAmYI+FJEM62yM63Dn1IUF+aNlGG1WLUN1eRTDj6acwquyp7i
         aB0hGCjUty/m/fny+xJhsDyPmw7kgooHjFcdg+VjOC3UKgH03ip9E48yOxPS18ol7+DQ
         QrmQ==
X-Gm-Message-State: AOAM533v/gp3y4SixZCFjX417T/UdN/9UQtUjd/ZKZ+IBfPJlwnL1moK
        /NbZxzOBoAqRe76BVRRhX6A=
X-Google-Smtp-Source: ABdhPJwON/Fs62ZvX5ajW1fuMBTnaaYI5fvdSlynTEE/cGVNseETu0dhn7AIV11BWy83gDWQW1Cx0A==
X-Received: by 2002:a63:904b:: with SMTP id a72mr7146183pge.66.1624582055212;
        Thu, 24 Jun 2021 17:47:35 -0700 (PDT)
Received: from nuc ([202.133.196.196])
        by smtp.gmail.com with ESMTPSA id x20sm3957374pfh.112.2021.06.24.17.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 17:47:34 -0700 (PDT)
Date:   Fri, 25 Jun 2021 08:47:30 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Suppress WARN on inability to sanitize EPC if
 ksgxd is stopped
Message-ID: <YNUnoqUsU2b1GC2C@nuc>
References: <20210616004458.2192889-1-seanjc@google.com>
 <YMmUHRGwXSIYJTDf@nuc>
 <20210623133219.v6c62zwtj5qowib3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210623133219.v6c62zwtj5qowib3@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Le Wed, Jun 23, 2021 at 04:32:19PM +0300, Jarkko Sakkinen a écrit :
> On Wed, Jun 16, 2021 at 02:03:09PM +0800, Du Cheng wrote:
> > Le Tue, Jun 15, 2021 at 05:44:58PM -0700, Sean Christopherson a écrit :
> > > Don't WARN on having unsanitized EPC pages if ksgxd is stopped early,
> > > e.g. if sgx_init() realizes there will be no downstream consumers of EPC.
> > > If ksgxd is stopped early, EPC pages may be left on the dirty list, but
> > > that's ok because ksgxd is only stopped if SGX initialization failed or
> > > if the kernel is going down.  In either case, the EPC won't be used.
> > > 
> > > This bug was exposed by the addition of KVM support, but has existed and
> > > was hittable since the original sanitization code was added.  Prior to
> > > adding KVM support, if Launch Control was not fully enabled, e.g. when
> > > running on older hardware, sgx_init() bailed immediately before spawning
> > > ksgxd because X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was
> > > unsupported.
> > > 
> > > With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check
> > > manually, so now there's any easy-to-hit case where sgx_init() will spawn
> > > ksgxd and _then_ fail to initialize, which results in sgx_init() stopping
> > > ksgxd before it finishes sanitizing the EPC.
> > > 
> > > Prior to KVM support, the bug was much harder to hit because it basically
> > > required char device registration to fail.
> > > 
> > > Reported-by: Du Cheng <ducheng2@gmail.com>
> > > Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > > 
> > > Lightly tested due to lack of hardware.  I hacked the flow to verify that
> > > stopping early will leave work pending, and that rechecking should_stop()
> > > suppress the resulting WARN.
> > > 
> > >  arch/x86/kernel/cpu/sgx/main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index ad904747419e..fbad2b9625a5 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -425,7 +425,7 @@ static int ksgxd(void *p)
> > >  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > >  
> > >  	/* sanity check: */
> > > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > > +	WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());
> > >  
> > >  	while (!kthread_should_stop()) {
> > >  		if (try_to_freeze())
> > > -- 
> > > 2.32.0.272.g935e593368-goog
> > > 
> > 
> > I applied this patch on 5.13-rc6, and it no longer causes to trigger WARN_ON()
> > on my NUC:
> > 
> > ```
> > 
> > [    0.669411] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > [    0.669412] software IO TLB: mapped [mem 0x0000000017cb9000-0x000000001bcb9000] (64MB)
> > [    0.672788] platform rtc_cmos: registered platform RTC device (no PNP device found)
> > [    0.672805] sgx: EPC section 0x30200000-0x35f7ffff
> > [    0.674239] Initialise system trusted keyrings
> > [    0.674254] Key type blacklist registered
> > 
> > ```
> > 
> > Regards,
> > Du Cheng
> 
> Can you thus give a tested-by for this?
> 
> /Jarkko

Certainly.

Tested-by: Du Cheng <ducheng2@gmail.com>

