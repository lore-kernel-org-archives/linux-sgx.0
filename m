Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49065C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Feb 2021 19:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06C2064DE0
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Feb 2021 19:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBZTxY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Feb 2021 14:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZTxW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 26 Feb 2021 14:53:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADBFC06174A
        for <linux-sgx@vger.kernel.org>; Fri, 26 Feb 2021 11:52:41 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z7so5849422plk.7
        for <linux-sgx@vger.kernel.org>; Fri, 26 Feb 2021 11:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fiDtBSrDM5VQf32jdhUorkZ49v06+aiMH0P6vHa7yco=;
        b=Vv3LrwgLGHNvhPopQXi5zrlDChuZ+S8i0rJ+kwqJZ/n42QbDBVvLC3ZUsOq+qtctL/
         CpfrskxHOPJTaSRHipK1nLFNLW6v/ap+ydnIxGnBILmPuDwzeSQjAiD+SpfJ83Ytc1N3
         PntbqeSbDQU1CiKLKrHXqjgdLOXugBH1jQcaXsc8IY6zhpFKU+3YEkfyNIocboWBFGMc
         rgfFXw6da2i1Lj51p1TLmfgto7gxRlpTb3kKEdNym9xNupbkG0+mZpJpUgryKBllis+i
         0sPZTZ2q4ztZ01j0CkQnJjFZTOQYAS4VNPCORkCJvq6vXlpC4KDFCYWx7ipM3krDcaRl
         wFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fiDtBSrDM5VQf32jdhUorkZ49v06+aiMH0P6vHa7yco=;
        b=W9/ffXou/XTKn+rsTmfiiApZFbFSH1RSx0ljma6Qc25U4sjerhV9Jpic2nXPeB0Nmr
         MedqhFvOkZZ7Hg0EgTRkrZSLdWlgXvUHsKyPdefRzLPyJ/WqBTRFiNp2YCdWkqGGgLNU
         0Sl0RkSUJVv0kFkco9kuHtstPfLutBqUythQ27u5alxexxYPPviKBHl2wnXuyEtAwdHW
         QWBD6tdcioSrKMjeydAer4kbjwUayET/HaVvDeMyS6J9R6d6N+rF5NbaZeVDzZg+XDAZ
         fFXP5eZMT3qGSP6yc4LjkyNhwbF/GgFak4Fj00xyQGNPAPJI6tXe1J7FVomjJnreV5yG
         a76A==
X-Gm-Message-State: AOAM531T4ozg+hnqbz3/asB0oxAkxToJv+J6PpQrtb2plvZtE33UYkfu
        vWYGth67SWfHyq3j8yMLxZgyag==
X-Google-Smtp-Source: ABdhPJwcATg72NLMgbE56tLKCFBXOsz7GYLXHW5rg3mdoN061Uo9Lt4SebiQvCxn9wNDzXqCQx+tFw==
X-Received: by 2002:a17:90a:aa05:: with SMTP id k5mr5093577pjq.106.1614369161159;
        Fri, 26 Feb 2021 11:52:41 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e190:bf4c:e355:6c55])
        by smtp.gmail.com with ESMTPSA id h186sm9706804pgc.38.2021.02.26.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 11:52:40 -0800 (PST)
Date:   Fri, 26 Feb 2021 11:52:34 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave@sr71.net>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v6 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YDlRgtnVS4+KkzUW@google.com>
References: <cover.1614338774.git.kai.huang@intel.com>
 <308bd5a53199d1bf520d488f748e11ce76156a33.1614338774.git.kai.huang@intel.com>
 <746450bb-917d-ab6c-9a6a-671112cd203e@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <746450bb-917d-ab6c-9a6a-671112cd203e@sr71.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 26, 2021, Dave Hansen wrote:
> On 2/26/21 4:14 AM, Kai Huang wrote:
> > @@ -404,7 +421,8 @@ void sgx_encl_release(struct kref *ref)
> >  			if (sgx_unmark_page_reclaimable(entry->epc_page))
> >  				continue;
> >  
> > -			sgx_free_epc_page(entry->epc_page);
> > +			if (!sgx_reset_epc_page(entry->epc_page))
> > +				sgx_free_epc_page(entry->epc_page);
> 
> Won't this leak the page?

Yep.

> I think that's fine; the page *IS* unusable if this happens.  But, the
> error message that will show up isn't super informative.  If this
> happened to a bunch of EPC pages, we'd be out of EPC with nothing to
> show for it.
> 
> We must give a more informative message saying that the page is leaked.
>  Ideally, we'd also make this debuggable by dumping out how many of
> these pages there have been somewhere.  That can wait, though, until we
> have some kind of stats coming out of the code (there's nothing now).  A
> comment to remind us to do this would be nice.

Eh, having debugged these several times, the WARN_ONCE in sgx_reset_epc_page()
is probably sufficient.  IIRC, when I hit this, things were either laughably
broken and every page was failing, or there was another ENCLS failure somewhere
else that provided additional info.  Not saying don't add more debug info,
rather that it's probably not a priority.

> Anyway, these are in decent shape and only getting better.  It's time to
> get some more eyeballs on them and get the RFC tag off, so assuming that
> a better error message gets stuck in here:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
