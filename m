Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A227BC47082
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 21:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBA1611C9
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 21:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCVkm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Jun 2021 17:40:42 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:34482 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCVkl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 3 Jun 2021 17:40:41 -0400
Received: by mail-pf1-f174.google.com with SMTP id g6so5924498pfq.1
        for <linux-sgx@vger.kernel.org>; Thu, 03 Jun 2021 14:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J7/cYQsiXvpqSV2tQbCfoC6ebqxSgkCINGphYDn/1Os=;
        b=W4baS+H1S1TCvwuJoHXRL04rduN16avTj9sEMDAkuRWrfjhiZkpFhChvZI+XS8tl2c
         gMD+/hybxCOvpJ+CxJFoFFqar5wlpa6DZohkYo30mzsSCW5H1h6IQCWJf00j3e+pqAtF
         6S5ONRiak5m4FTReStXLqUHYuxKP2AcrChcJInbWctBRIsS/z/9Tav9eRsaEaNNc3PNM
         qq5Uc8KPn2ptlND57hKNSxz6aDQU6yhrtw8WAslAcZwgyYhlupELBSw9vIjlfJ3tjRqT
         GKq81YAdBKdzqCXxveWBzafTajgJFIlxOZotrpkbkEPIFSOwrG+9BB/J5gEF7xuYXvZt
         mhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7/cYQsiXvpqSV2tQbCfoC6ebqxSgkCINGphYDn/1Os=;
        b=Up6sIU3WJHt27YlxMOqYnAYp7hmdWUVKrXbW/tfA8x2VI29C/Xxfq9+VJkqIWNEyh/
         ROEHM5KG6oZXcFa6DMPVSHsqqp5e8XHHOmEiWixyr2wl5tyt4YpaZj9Cxz+mwUeZbWKs
         NVQtxRXyMuu1DhRO7kCqOqHkTn1ufynE7wIu6eqR7nOkWTNu1+aaF5/Noy4+TgPJnK9n
         c5/qVIb+SHWvje6sGlJxxbdPp3whTtpXQWXwfLtR/KPY8kqBnP6Z5qkR0e6GA39lRlVO
         jPpuSkxM0pX2mrnpOqnueFibl8XuqxmJ/Pxo/MoWui1H7N2YKpQw06iNg++T+tXYbaLk
         8V6g==
X-Gm-Message-State: AOAM531R3DRnSRM99yGcUTEsaRRidqeMguGpREScYm/JnJ8DuQSofJDO
        N3AQiDU3YgP1st2+5KX345lwQQ==
X-Google-Smtp-Source: ABdhPJzKsrT3xEgAPoFtROl7fj+826V3GD9hN5d40VJsQ4tPO8Emq5XD5X9Fz66vCMsYtYoQRpvMGw==
X-Received: by 2002:a63:f40d:: with SMTP id g13mr1515544pgi.290.1622756276354;
        Thu, 03 Jun 2021 14:37:56 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c15sm50013pgt.68.2021.06.03.14.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 14:37:55 -0700 (PDT)
Date:   Thu, 3 Jun 2021 21:37:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Du Cheng <ducheng2@gmail.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, dave.hansen@intel.com
Subject: Re: [BUG] bug report on x86/sgx: ksgxd()
Message-ID: <YLlLsJQAQ5uQk+hf@google.com>
References: <YLb8y5YMFAsRKJMg@nuc>
 <20210603065745.v3iupi3k3oxea424@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603065745.v3iupi3k3oxea424@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 03, 2021, Jarkko Sakkinen wrote:
> On Wed, Jun 02, 2021 at 11:36:43AM +0800, Du Cheng wrote:
> > Hi,
> > 
> > I like to report a bug on my linux box running the mainline linux of version:
> > commit 8124c8a6b35386f73523d27eacb71b5364a68c4c tag: v5.13-rc4
> > 
> > After it boots on my intel NUC, I encounter this error in the console log, I
> > believe it is triggered by a WARN_ON():
> > 
> > [    0.628094] sgx: EPC section 0x30200000-0x35f7ffff
> > [    0.628503] ------------[ cut here ]------------
> > [    0.628506] WARNING: CPU: 6 PID: 127 at arch/x86/kernel/cpu/sgx/main.c:428 ksgxd+0x1c8/0x1e0
> > 
> > 
> > I have attached my config file with which I compiled the kernel, just in case it is helpful.
> > 
> > I am running on ubuntu 21.04 with mainline kernel, and my box is intel NUC:
> > 
> > 	Product Name: NUC10i5FNH
> > 	SKU Number: BXNUC10i5FNH
> > 	Product Name: NUC10i5FNB
> 
> Is it possible to test with 5.12?
> 
> Linux does not support that hardware, except for KVM VM's, which was
> added in 5.13.

I'm pretty sure that the issue is kthread_stop() being called on ksgxd before
__sgx_sanitize_pages() completes, and that lack of launch control is what is
exposing the bug.

Prior to adding KVM support, sgx_init() bailed immediately because
X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was unsupported.

With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check manually,
so now there's any easy-to-hit case where sgx_init() will spawn ksgxd and _then_
fails to initialize, which results in sgx_init() stopping ksgxd before it finishes
sanitizing the EPC.

The bug existed before KVM support, it was just much harder to hit because it
basically required char device registration to fail.

This should suppress the WARN if ksgxd is stopped early.

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..bdf31ddfb10d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -425,7 +425,7 @@ static int ksgxd(void *p)
        __sgx_sanitize_pages(&sgx_dirty_page_list);

        /* sanity check: */
-       WARN_ON(!list_empty(&sgx_dirty_page_list));
+       WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());

        while (!kthread_should_stop()) {
                if (try_to_freeze())


If that works, then

  Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")

is probably most appropriate.
