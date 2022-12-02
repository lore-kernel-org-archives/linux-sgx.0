Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F967C4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Dec 2022 22:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiLBWgY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Dec 2022 17:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiLBWgC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Dec 2022 17:36:02 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3523AFA45B
        for <linux-sgx@vger.kernel.org>; Fri,  2 Dec 2022 14:35:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id w37so5506503pga.5
        for <linux-sgx@vger.kernel.org>; Fri, 02 Dec 2022 14:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3AsPBlStxM5I2Ol3fQv4IigRWmDsbShzT0tHCkMWpc=;
        b=ODGW++iHa9F+rS6SwwuY93cCe2n+w1WZcRsza8S7XVaW4m0QTCHPGuWrWU0YbABHDT
         jjKouQfhsXnhHWR7hV/UnqPxP9JQMq4+wyMM6M7Q1stGl6Lo7/thVMCPwtolJsk+yNa0
         pIo7PPrDZdwNXrX9sAb3/rR9JFpaHOlctjjyBx8Z0e8LCsX+z3syP4TZPf23YmiDuat8
         ls3MGIOXTJeSlwXRetecOnRzC1pZ7DogR0v9Uqrfi7XJrJBiKPNpyqWviLmix5yedLMa
         +2FHfJgGbV85dhz2J0zpsbsaVGOWLil1D7qyI1wnnC6fTKpwqdv1L2GL79hx2FfYZn6N
         sTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3AsPBlStxM5I2Ol3fQv4IigRWmDsbShzT0tHCkMWpc=;
        b=hoNC/uJgpiJdxCqqQd3PrN6kdS+wJREzo0NNzAWYGi4umxhDiUVXHsb41OREtliVGL
         91EW9dNWipsE1COUszXW1sbBvt7aBbkzvCn12K0EDNe/civNTI8r/xxylDd1Rt9a5P1l
         BHsHzGwLR2ZOxlevnbp5MkE4XUi4E1DsSBFCPFErQ0WCcePoX0VpL+1IcdxgUX8Xs1xB
         DH9ujJUfvZuyAZ4ZjF8dTRKQnJSQbQ+nwBMzZnHMIPb65W+j01JoAOUa9w3gNdmENuPa
         Ah/MpcJqENRnq28JxqrQcou5vbxa4lzki3ic7PcuqNoXxrQR0na1wlRL9UOVWfFir1Ei
         MO7A==
X-Gm-Message-State: ANoB5pnrFE2rrZqPKzJGM9ns4XK/ZrS7F4UpVkiyDCEtqqJl80l0icTH
        RHNe+LMpNoO2LokEbRdPv4auPA==
X-Google-Smtp-Source: AA0mqf7nH73xcxVT1coc+0CqH8zWWPgkL4uiAQR/zMxNI0Rnz4QS+6fzpb85FA1LUptLIDNgDK9eBg==
X-Received: by 2002:aa7:954e:0:b0:574:36b6:f91b with SMTP id w14-20020aa7954e000000b0057436b6f91bmr50736002pfq.55.1670020512590;
        Fri, 02 Dec 2022 14:35:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 3-20020a631543000000b0044ed37dbca8sm4573520pgv.2.2022.12.02.14.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:35:12 -0800 (PST)
Date:   Fri, 2 Dec 2022 22:35:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        zhiquan1.li@intel.com
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Message-ID: <Y4p9nKV+jpLnOVwD@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-3-kristen@linux.intel.com>
 <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
 <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel@linux.intel.com>
 <2015ae96-5459-1f82-596b-f46af08ef766@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2015ae96-5459-1f82-596b-f46af08ef766@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 02, 2022, Dave Hansen wrote:
> On 12/2/22 13:40, Kristen Carlson Accardi wrote:
> > On Fri, 2022-12-02 at 13:35 -0800, Dave Hansen wrote:
> >> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> >>> When allocating new Version Array (VA) pages, pass the struct
> >>> sgx_encl
> >>> of the enclave that is allocating the page. sgx_alloc_epc_page()
> >>> will
> >>> store this value in the encl_owner field of the struct
> >>> sgx_epc_page. In
> >>> a later patch, VA pages will be placed in an unreclaimable queue,
> >>> and then when the cgroup max limit is reached and there are no more
> >>> reclaimable pages and the enclave must be oom killed, all the
> >>> VA pages associated with that enclave can be uncharged and freed.
> >> What does this have to do with the 'encl' that is being passed,
> >> though?
> >>
> >> In other words, why is this new sgx_epc_page-to-encl mapping needed
> >> for
> >> VA pages now, but it wasn't before?
> > When we OOM kill an enclave, we want to get rid of all the associated
> > VA pages too. Prior to this patch, there wasn't a way to easily get the
> > VA pages associated with an enclave.
> 
> Given an enclave, we have encl->va_pages to look up all the VA pages.
> Also, this patch's code allows you to go from a va page to an enclave.

Yep.

> That seems like it's going the other direction from what an OOM-kill
> would need to do.

Providing a backpointer from a VA page to its enclave allows OOM-killing the enclave
if its cgroup is over the limit but there are no reclaimable pages for said cgroup
(for SGX's definition of "reclaimable").  I.e. if all of an enclave's "regular"
pages have been swapped out, the only thing left resident in the EPC will be the
enclave's VA pages, which are not reclaimable in the kernel's current SGX
implementation.
