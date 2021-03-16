Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D00AC433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Mar 2021 01:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A8164F37
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Mar 2021 01:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhCPBOY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 21:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbhCPBOC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Mar 2021 21:14:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45CAC06175F
        for <linux-sgx@vger.kernel.org>; Mon, 15 Mar 2021 18:14:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g4so21539184pgj.0
        for <linux-sgx@vger.kernel.org>; Mon, 15 Mar 2021 18:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4dVvMOxTk9Ypr/9Lo2OLdOhByXF6SXWR6ay9T+ieRSM=;
        b=EZFHovhmAoopzS1sAyFz8LZ7cQ4s1NK8pswQycEvqXhf+v2AtqQRio3wz0Cr2LGLCl
         WFcPiZnXP9sJan5FmBlCbSTYLFEaGqU3YPyO0p10SMLagxja8xgN1e8zp3ZGeYSJ7PJ8
         E5vu4fW2VKc26IxakxgX0z9ysMaXZ+NLF4F+Px6KnZax+vUAx2vFOUuCAue1UmLSf9EK
         80JpMGeXlotsuJoHyec6+eBJHR3keP0EJPLXId0oeQQVLOKCWX86DWBX7Um7lVRPqaaD
         OAbOirxOoBvg0rS42HGrAosq2kbuFjH0MHnbZFPQNWxbp7h594r434iu3RtArsvp2kBD
         eaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dVvMOxTk9Ypr/9Lo2OLdOhByXF6SXWR6ay9T+ieRSM=;
        b=ktS8UNT8JRwrZQtd/JmMiYfT/S+ZIhSGZYBQ+SZR9HdknlxedgRbMw0Ed55Qwasqbp
         1ZNDvPr6dpauc9yPDDTJthwYuTUk/kHjJH2oVCHDs2s2vWrepa8GckbAW2KTUW0SzmO0
         EznwvLtR9hSwhHw0uXwyMnDPUkxuVFOH1kAJ6YEPj8iLnts5wetfFLlRMdXYHe+SmOoe
         wgYowswiyflRE+pdtpsOfzueg+5BOSob6//4Tc9hdosD4p5oPXGlsO0NTAZYqxCBQSew
         Z1KqZ8+hw0vDKWJ9iiKOiwOyj/oWYzdS4Lq/qcbnr1xvr+X84dNyhyi/t7zS6RZHXKvK
         EbSA==
X-Gm-Message-State: AOAM53347RtI6/QawfU/Rw5FUNmHiOJ6fr0LREuo/ijJYjejin2JL8az
        7esCg+RQ3JY2aoZOkG6ab014uQ==
X-Google-Smtp-Source: ABdhPJyXX8OZIUCZQti15KySpaCRN20Com+8qtotY7KMLGFuHxyDNwcGtBBg+UsS29oa3WcAGUSaLA==
X-Received: by 2002:a63:dd15:: with SMTP id t21mr1506443pgg.23.1615857240996;
        Mon, 15 Mar 2021 18:14:00 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id z8sm833992pjd.0.2021.03.15.18.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 18:14:00 -0700 (PDT)
Date:   Mon, 15 Mar 2021 18:13:53 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YFAGUWDYacz1zroI@google.com>
References: <YE0M/VoETPw7YZIy@kernel.org>
 <YE0NeChRjBlldQ8H@kernel.org>
 <YE4M8JGGl9Xyx51/@kernel.org>
 <YE4rVnfQ9y7CnVvr@kernel.org>
 <20210315161317.9c72479dfcde4e22078abcd2@intel.com>
 <YE9beKYDaG1sMWq+@kernel.org>
 <YE9mVUF0KOPNSfA9@kernel.org>
 <20210316094859.7b5947b743a81dff7434615c@intel.com>
 <YE/oHt92suFDHJ7Z@kernel.org>
 <YE/o/IGBAB8N+fnt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE/o/IGBAB8N+fnt@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 16, 2021, Jarkko Sakkinen wrote:
> On Tue, Mar 16, 2021 at 01:05:05AM +0200, Jarkko Sakkinen wrote:
> > The way I've understood it is that given that KVM can support SGX
> > without FLC, vEPC should be available even if driver cannot be
> > enabled.
> > 
> > This is also exactly what the short summary states.
> > 
> > "Initialize virtual EPC driver even when SGX driver is disabled"
> > 
> > It *does not* state:
> > 
> > "Initialize SGX driver even when vEPC driver is disabled"
> > 
> > Also, this is how I interpret the inline comment.
> > 
> > All this considered, the other direction is undocumented functionality.
> 
> Also:
> 
> 1. There is *zero* good practical reasons to support the "2nd direction".

Uh, yes there is.  CONFIG_KVM_INTEL=n and X86_FEATURE_VMX=n, either of which
will cause vEPC initialization to fail.  The former is obvious, the latter is
possible via BIOS configuration.

>    For KVM getting init'd with SGX, on the other hand, we have good
>    practical reasons.
> 2. We can get something practically useful with simpler and more verbose
>    code, i.e. better logging.
> 
> /Jarkko
