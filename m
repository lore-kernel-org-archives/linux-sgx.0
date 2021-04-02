Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D274C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBAB6115B
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhDBTad (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhDBTac (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Apr 2021 15:30:32 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C441C0613E6
        for <linux-sgx@vger.kernel.org>; Fri,  2 Apr 2021 12:30:30 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f10so4099803pgl.9
        for <linux-sgx@vger.kernel.org>; Fri, 02 Apr 2021 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mI2VwoucIGtwJkYw4jcbD6VsEjZ7aBO9iaogKVD4nI4=;
        b=KK2Kxxc4pkTexwVVGgJh/v3IhjphLvlaQKCImf4D6lAGS/OdKWcPPWAI+eTtnLJTeh
         nvX2apmNv/KMyLksk6sFFf2ztsd60zapv+9zdIcqjg1Z1Aa/fXESufNKsqtjIke5WQHt
         M0aG3TYe5f329OkBh/5aRwpQxCZRm57zZCvNnVVD/5SLohli1J+RMMmFCKU/pw3iLYAQ
         eHlZZjHe6dIwkHctw7SAmhSLbimCLbQgXdw9D0j+vDyLgO0zRXqUWTxLjE6wGz5k5GGV
         RGVxOAen6cBUcfr72E2gb1xq0kxs41Oio01KmGwmrzqQyIw0Ycu+FzgY/iJOTTSRrHFU
         fAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mI2VwoucIGtwJkYw4jcbD6VsEjZ7aBO9iaogKVD4nI4=;
        b=fK2qgTHTFcdIm/SRYHdvF8sjXjtPkEMp1zMXhI4zZ1mNti3A5SEMi3Jky67hHq9+j9
         ZUaMvFj49PdveKwr59oKMMLoNmAVaNo2arABisDGIyaXs//kdaUIS2W7PkcWskor0YEr
         akAAa+SlPLyGgNc/DJszzbJGXjeU29P/L0AldOBN8+9XB0OHK4iOnM4IfYES/4sEtsSp
         kGQBauqhGRhZg1cJeISde0JUGPfx1IJo/i0wUGpCFHmKhYy4ab+O7EmcuQxEs+3VlOKJ
         M/TlnIX0zo2boKzUDQhQ1UDdbQvAyQkvbb6yESPbrazUcqxQ8VcgZuhWRumqm1lMKoBE
         7dgQ==
X-Gm-Message-State: AOAM5337DbcCCNJbsKIg/YpPbqzYXg5ypcMBp/CrvvBTEUPDLnVuyKB3
        xLsqd5nT8z2CADwLq/7XOx7apw==
X-Google-Smtp-Source: ABdhPJz+IwEe6kNxDW16gUdkP1UiHKndPYJHb24Xo12t7nWY35muI9rAeFyqM0+2dx4Uv3yTO8KcnA==
X-Received: by 2002:aa7:8d8a:0:b029:1f8:aa27:7203 with SMTP id i10-20020aa78d8a0000b02901f8aa277203mr13370981pfr.64.1617391828115;
        Fri, 02 Apr 2021 12:30:28 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s8sm8799796pjg.29.2021.04.02.12.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 12:30:27 -0700 (PDT)
Date:   Fri, 2 Apr 2021 19:30:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YGdwzzvsKTXJeioa@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
 <20210402094816.GC28499@zn.tnic>
 <YGc7ezLWEu/ZvUOu@google.com>
 <20210402191946.GL28499@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402191946.GL28499@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 02, 2021, Borislav Petkov wrote:
> On Fri, Apr 02, 2021 at 03:42:51PM +0000, Sean Christopherson wrote:
> > Nope!  That's wrong, as sgx_epc_init() will not be called if sgx_drv_init()
> > succeeds.  And writing it as "if (sgx_drv_init() || sgx_vepc_init())" is also
> > wrong since that would kill SGX when one of the drivers is alive and well.
> 
> Bah, right you are.
> 
> How about:
> 
> 	/* Error out only if both fail to initialize. */
>         ret = sgx_drv_init();
> 
>         if (sgx_vepc_init() && ret)
>                 goto err_kthread;

Heh, that's what I had originally and used for literally years.  IIRC, I
suggested the "!! & !!" abomination after internal review complained about the
oddness of the above.

FWIW, I think the above is far less likely to be misread, even though I love the
cleverness of the bitwise AND.

> 
> And yah, this looks strange so it needs the comment to explain what's
> going on here.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
