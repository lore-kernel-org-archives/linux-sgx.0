Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191E2C433C1
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 16:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC6C619C6
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 16:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhCWQv2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbhCWQvR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 23 Mar 2021 12:51:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4A5C061764
        for <linux-sgx@vger.kernel.org>; Tue, 23 Mar 2021 09:51:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h3so14905056pfr.12
        for <linux-sgx@vger.kernel.org>; Tue, 23 Mar 2021 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ff/dfLlyOzHdPDlHSVc6uKmy6e9wrU4ymq44nCy5dSM=;
        b=nb6k9RMnO0SEpqDMoEDygbgq2JdmkHlxt1rj4O4DPF3FfLzdzrb1HzBmiPwjdEUSFm
         HlBnfo+jMkiM3CBQPw38e7kKqnKYVEnaz3nro04L0pmVRp9u/JaRf/UZ0FJhxZL4xuSi
         dToiOiF52H0DGvZLrg1e8KroAywJLNR5CFsecizgvNVf5vu8VtCxTEuTmg5hEKlaU8vx
         tlcBmvraUqDOPZF7lMP87EJuARXwppJvtbBIYu0YgT1PnBM+KHSRoixvUp2V2LsWnbVH
         iHnC+8nSdL0QBmf8KuuPa8T4iaffHKVcIZBhZZNBA7DtVT/4it5mUUbR0rBVTWIjxYxq
         3rFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ff/dfLlyOzHdPDlHSVc6uKmy6e9wrU4ymq44nCy5dSM=;
        b=ZiVCR9FARxuHKTZOV3/Gqw0uiQo4plEd0kgshosLFKJw4sSqc/7/FCznkaGjlLFFdU
         GCaut/KffxvmqqAo6Nr34eFcuBdbWCa5kwsuCLhgOgWJk/9IvHo2xblyJe9LkRogpS5b
         Z1In/GA0h8lH4/iGA97tffrWDodahA+o1nwftZZgVD/AExl56PeJeOLfoTvPBQzR6K7a
         tkjRDvYvlaZTY7IQkBKgtp5fAiQNwVFD/50QSUQbBS+yo32Vcgs2XAnNtKPkPlkpGuYM
         lNNeCn3B+I9plSr+EuvBZpVVyM1cdJEGNaiS3xBy89HTxscuKeFjXhUkAn0JQ76jUdFl
         QMwA==
X-Gm-Message-State: AOAM533T04LtPVfhwTWjoLBzVOFjeJTZblpPks9mxcSCGralZcZxWxnt
        fqyH22br//OAiekmN/VeT1rfEQ==
X-Google-Smtp-Source: ABdhPJz4JugX4G1Rb9cwl4cMNKr/OKCMAwe/BTVthjUPsMDOQCAN4SeXCCedrmITaBENodfs7st8oQ==
X-Received: by 2002:aa7:9989:0:b029:1f5:aa05:94af with SMTP id k9-20020aa799890000b02901f5aa0594afmr5783950pfh.34.1616518276602;
        Tue, 23 Mar 2021 09:51:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p3sm15783705pgi.24.2021.03.23.09.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 09:51:16 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:51:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFocgJ+OD/0rCsvg@google.com>
References: <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com>
 <20210323163258.GC4729@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323163258.GC4729@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 23, 2021, Borislav Petkov wrote:
> On Tue, Mar 23, 2021 at 04:21:47PM +0000, Sean Christopherson wrote:
> > I like the idea of pointing at the documentation.  The documentation should
> > probably emphasize that something is very, very wrong.
> 
> Yap, because no matter how we formulate the error message, it still ain't enough
> and needs a longer explanation.
> 
> > E.g. if a kernel bug triggers EREMOVE failure and isn't detected until
> > the kernel is widely deployed in a fleet, then the folks deploying the
> > kernel probably _should_ be in all out panic. For this variety of bug
> > to escape that far, it means there are huge holes in test coverage, in
> > both the kernel itself and in the infrasturcture of whoever is rolling
> > out their new kernel.
> 
> You sound just like someone who works at a company with a big fleet, oh
> wait...
> 
> :-)
> 
> And yap, you big fleeted guys will more likely catch it but we do have
> all these other customers who have a handful of servers only so they
> probably won't be able to do such a wide coverage.

The size of the fleet shouldn't matter for this specific case.  This bug
requires the _host_ to be running enclaves, and obviously it also requires the
system to be running SGX-enabled guests as well.  In such a setup, the SGX
workload running in the host should be very well defined and understood, i.e.
testing should be a well-bounded problem to solve.

Running enclaves in both the host and guest should be uncommon in and of itself,
and for such setups, running _any_ SGX workloads in the host, let alone more
than 1 or 2 unique workloads, without ensuring guests are fully isolated is,
IMO, insane.

But yeah, what can happen, will happen.
 
> So I hope they'll appreciate this longer explanation about what to do
> when they hit it. And normally I wouldn't even care but we almost never
> tell people to reboot their boxes to fix sh*t - that's the other OS.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
