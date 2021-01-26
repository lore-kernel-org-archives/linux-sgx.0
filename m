Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693B6C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 17:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F31C2083E
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 17:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbhAZRUn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392971AbhAZQaz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 Jan 2021 11:30:55 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9DC061574
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 08:30:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id e9so2532264pjj.0
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 08:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PaCzCYCH4aX6Kv1jMmoIcCojESLo94WkAXAYpiqsmdk=;
        b=RGq1J9JqSlV5ElJQhgbRf54UqcTFczVkcyVGQuLoiue+YDzh+JSKx55lyZrvbEs+EL
         kUdM4CYnu+FMiisy6t0l+ULhDp8YDOJFJdbbs/Qsr6L+lgKyC4N/njPLagnNIv1KjUqN
         79fW1VXUcxxlm1zc2wm84yNjalDPaHuHvKp9gTe+LecWcdur4CTFPa3TBAyRNASIWLpa
         jxZV2i2yeGez5sOkZy2611JJp1eWG2X/m95W80B71A4zCS2oI7q0C1JrO0gs4GngZMPG
         kB0OK7LP8WUkvV8QkfLFjYXXmKwbNNkC8X/iFP4GscoYsILs0edXrPDVsKF6/w1R9foU
         06HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PaCzCYCH4aX6Kv1jMmoIcCojESLo94WkAXAYpiqsmdk=;
        b=XRjIG9dT1xtRsnfjasV6zwiY2LHMJh2P2C3HJ/JWU9eSw3xvtGn2IfBBU1k9L9B/CD
         ahr3REqL+G68fdgOMzRpCTupYtrb7EnWsLLc1vqEZAjTINXi6/xLgIhaeoRrMNmIAYLo
         HkizGUvAyGxrqD0rlMk96ibt2hcjNK1WtOWw73sNs8JpzIObQm40vW/8GgI116eonSdp
         JKNoFns1YFrBF+Kn8XbW9y1tk/MzzEzNLmknZU48S1PAWsGLkxh4QgojZsw0Gr1bSeN5
         M4T8hcZafkiB9SivgXzcAGAIoT+Yo3wokrFu2gV8d2fynfsKndR/TWfaQXkQrscF22n8
         QJPA==
X-Gm-Message-State: AOAM533R4bstf35+0y6bKhymiARhMNq3mChH5KklQpxw5piEySFzXcdt
        Sm2sB403e+VZoacLi6xNWJSoLA==
X-Google-Smtp-Source: ABdhPJwsKX0DV4kpdoFHr+1Rt0SRbjKnOiNtYc6LXPTb0BN3J77r+R9VhmAyqGrQhmlCaGL4aIc0uA==
X-Received: by 2002:a17:90a:4504:: with SMTP id u4mr604587pjg.218.1611678614297;
        Tue, 26 Jan 2021 08:30:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id v9sm2656146pju.33.2021.01.26.08.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 08:30:13 -0800 (PST)
Date:   Tue, 26 Jan 2021 08:30:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from
 sgx_free_epc_page()
Message-ID: <YBBDj4zCDvbgLgS0@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
 <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 26, 2021, Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
> > happen, as enclave pages are freed only at the time when encl->refcount
> > triggers, i.e. when both VFS and the page reclaimer have given up on
> > their references.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 8df81a3ed945..f330abdb5bb1 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -605,8 +605,6 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> >  	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> >  	int ret;
> >  
> > -	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> 
> I'm all for cleaning up silly, useless warnings.  But, don't we usually
> put warnings in for things that we don't expect to be able to happen?
> 
> In other words, I'm fine with removing this if it hasn't been a valuable
> warning and we don't expect it to become a valuable warning.

Ya, I don't understand the motivation for removing this warning.  I tripped it
more than once in the past during one of the many rebases of the virtual EPC
and EPC cgroup branches.
