Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6E8C433B4
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 15:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA9161220
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 15:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352505AbhDNPxN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Apr 2021 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352536AbhDNPv5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 14 Apr 2021 11:51:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E155C061345
        for <linux-sgx@vger.kernel.org>; Wed, 14 Apr 2021 08:51:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so12774881pjb.0
        for <linux-sgx@vger.kernel.org>; Wed, 14 Apr 2021 08:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWTfBwhTBFykGiu2dJZUXA73h5DF2jNYyWILelcjCss=;
        b=CFA/7opwET+k+CkWLRylF35NIqQ0lptLoj4zlqd4GJRMkCn1aBrIxS+E0C63Mt2RRX
         prqoK+tBeeWTPQrLN+ZPAbfrGPPu3LWMGB+sXDWw0yfsul03W1fH+z4bVRl5xdAZscJ1
         V3koDyPyoBAZcNcSeiuzu0pja/ZMDCyhJbLdzFUMEXX90TxZo4bUVB3HfFF1GqEDR5hc
         rv6PlBv2K9/Si94ULnlv/CU3Iw+3NpmGy3QXIEejtkw5R5rK168loJIu2bxTbqTyyhNx
         NHOd4+D7g4CwXMWtYevoBXRY68QSPEaF1cxR4eBk2ouewUNRzvhUAvJIiaHDN/AE1XT6
         NnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWTfBwhTBFykGiu2dJZUXA73h5DF2jNYyWILelcjCss=;
        b=LGK8RWXbRtqtqEYCzGj7dr1yYEiSJ7yOWcW/voXGatKmvW150kSbncyxGD9Zezowwo
         2M1ZodipivlJ3wwygDCNCypWUMxeDzWRkw2zWmHj1ccdxhNwn8NOQWdcs7fzvjeD7hoR
         uZb5oFkOZpxFnNnn1xn5sMiQut61s99BSRhsH3eJMaPRt5TF/zpVlxEaM4nyHa1MnTvG
         f2WW5V2f4OffuIN7POA7m3Z3m+QXbFX4o48j/q1TyvYIY31c1bYIlRb5GKaO3J4fAWKW
         W6DM0lrwwRHxSe+ylKnrOn8fi2v4EX90PU/cP6acXtpckuwGlLdOA7aITLfXCouzhbwk
         b+MQ==
X-Gm-Message-State: AOAM5334ZGe6dCfh5IXqaHX3xas6ipxsPzWyDXrjtU6wjaBU8lt6gqAU
        pFQ6nRY4sgItT5ZsBm1Fty120g==
X-Google-Smtp-Source: ABdhPJxN8qkEtKV5OE7Nm+uT6kF+BbXMmPzqy99b5bxZ9iI9qlaGB4po76jLI9QjL4beUR/E7Xiugw==
X-Received: by 2002:a17:902:bb91:b029:e6:bc94:4899 with SMTP id m17-20020a170902bb91b02900e6bc944899mr38307640pls.25.1618415489902;
        Wed, 14 Apr 2021 08:51:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w3sm5064306pjg.7.2021.04.14.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:51:28 -0700 (PDT)
Date:   Wed, 14 Apr 2021 15:51:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        dave.hansen@intel.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] x86/sgx: Maintain encl->refcount for each
 encl->mm_list entry
Message-ID: <YHcPfRqKCx+KXwoJ@google.com>
References: <20210207221401.29933-1-jarkko@kernel.org>
 <op.01te3jzwwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.01te3jzwwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 13, 2021, Haitao Huang wrote:
> On Sun, 07 Feb 2021 16:14:01 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > This has been shown in tests:
> > 
> > [  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374
> > cleanup_srcu_struct+0xed/0x100
> > 
> > This is essentially a use-after free, although SRCU notices it as
> > an SRCU cleanup in an invalid context.
> > 
> The comments in code around this warning indicate a potential memory leak.
> Not sure how use-after-free come into play. Anyway, this fix seems to work
> for the warning above.
> 
> However, I still have doubts on another potential race. See below.
> 
> 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c
> > b/arch/x86/kernel/cpu/sgx/driver.c
> > index f2eac41bb4ff..8ce6d8371cfb 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -72,6 +72,9 @@ static int sgx_release(struct inode *inode, struct
> > file *file)
> >  		synchronize_srcu(&encl->srcu);
> >  		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> >  		kfree(encl_mm);
> 
> Note here you are freeing the encl_mm, outside protection of encl->refcount.
> 
> > +
> > +		/* 'encl_mm' is gone, put encl_mm->encl reference: */
> > +		kref_put(&encl->refcount, sgx_encl_release);
> >  	}
> > 	kref_put(&encl->refcount, sgx_encl_release);
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > b/arch/x86/kernel/cpu/sgx/encl.c
> > index 20a2dd5ba2b4..7449ef33f081 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -473,6 +473,9 @@ static void sgx_mmu_notifier_free(struct
> > mmu_notifier *mn)
> >  {
> >  	struct sgx_encl_mm *encl_mm = container_of(mn, struct sgx_encl_mm,
> > mmu_notifier);
> > +	/* 'encl_mm' is going away, put encl_mm->encl reference: */
> > +	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
> > +
> >  	kfree(encl_mm);
> 
> Could this access to and kfree of encl_mm possibly be after the
> kfree(encl_mm) noted above?

No, the mmu_notifier_unregister() ensures that all in-progress notifiers complete
before it returns, i.e. SGX's notifier call back is not reachable after it's
unregistered.

> Also is there a reason we do kfree(encl_mm) in notifier_free not directly in
> notifier_release?

Because encl_mm is the anchor to the enclave reference

	/* 'encl_mm' is going away, put encl_mm->encl reference: */
	kref_put(&encl_mm->encl->refcount, sgx_encl_release);

as well as the mmu notifier reference (the mmu_notifier_put(mn) call chain).
Freeing encl_mm immediately would prevent sgx_mmu_notifier_free() from dropping
the enclave reference.  And the mmu notifier reference need to be dropped in
sgx_mmu_notifier_release() because the encl_mm has been taken off encl->mm_list.
