Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FED6C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Feb 2021 22:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B2964ED5
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Feb 2021 22:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBZWfZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZWfZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 26 Feb 2021 17:35:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F69C061574
        for <linux-sgx@vger.kernel.org>; Fri, 26 Feb 2021 14:34:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s23so6967728pji.1
        for <linux-sgx@vger.kernel.org>; Fri, 26 Feb 2021 14:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Joz7f24QnnxewLllirX/ZIoWPXA5ldI5c4mM+WeSQyg=;
        b=WmfTC+QGWmT8QNUXUUaILVKCS+3acc5vgFONkWE2IElpeHR3G77DVMok7u6a/xbKP3
         aydPpJ00Fu+t44++6od8vIb/pfcofOvzGmXcEBAl7e+O3DJgJuUb0Yc3qb9oyxHTdPbH
         oJ3Bec+m2sVN7ztsVWJV1bbeO9SHpRI93wZFQ8+N8z5xZKf2P0CBYKoMq4l+6dvbqg99
         I59z710bYY8p0riwzPCtFTRaVViZmG8TslRjP0h5TSiRO9k73kWibcNzs/duXZ38sdHU
         sNQNE+YsYsTMfMTiLzdJOWH4MzjUC8DEEhPU40HHLhm7zVmJ8R2tSmonFEpYge5CK/L0
         Sgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Joz7f24QnnxewLllirX/ZIoWPXA5ldI5c4mM+WeSQyg=;
        b=BfUkjElHqw4AOReGF8I+73SxZADpd4x/dek2AhiPOO17HSPv4hn+59gdNfG+5URG0B
         i6Q8SGFPlns/obEoChWtrSl12tou7zh2PlrtOXzaJm+t+BHZupBGipijX+DriwvJn1lC
         G0Xc/wfwzqBW3+bqtHp/dbO8LKdp6jc99fgKDRRN/D3wTR+a/8RwZUyUVoPnZVUOWaAQ
         RBKJUpGaF+jVniQs0tD9KezqKiRELWJLVL9AAhOOtN9KauCTan7kmbRiQ7s/mxpMPOj0
         A6LeVImDPjuY9uh4TmAQlbaqsRKKD7LDI8s2SoiCntRd9Dn8qSPF6wAYZ8kYHByCzL5Q
         q49Q==
X-Gm-Message-State: AOAM532e3f7Ko10S1CGlF3mO6x2Am7+WcfEI82RG0K9MZa1HMM5s02Rn
        RsFjsVzOFLeC5h7y85BQ4D64sQ==
X-Google-Smtp-Source: ABdhPJyIAprGG60fuQNZQv79X6q90PZvn6mAwuuY4iaLsqStXaV7kV76EJv+JTNOEvC2Krm6nwdIow==
X-Received: by 2002:a17:90a:6383:: with SMTP id f3mr5437829pjj.14.1614378884331;
        Fri, 26 Feb 2021 14:34:44 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e190:bf4c:e355:6c55])
        by smtp.gmail.com with ESMTPSA id e185sm10755991pfe.117.2021.02.26.14.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 14:34:43 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:34:37 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave@sr71.net>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v6 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YDl3fTOZiQe5O7jW@google.com>
References: <cover.1614338774.git.kai.huang@intel.com>
 <308bd5a53199d1bf520d488f748e11ce76156a33.1614338774.git.kai.huang@intel.com>
 <746450bb-917d-ab6c-9a6a-671112cd203e@sr71.net>
 <YDlRgtnVS4+KkzUW@google.com>
 <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 26, 2021, Dave Hansen wrote:
> On 2/26/21 11:52 AM, Sean Christopherson wrote:
> >> We must give a more informative message saying that the page is leaked.
> >>  Ideally, we'd also make this debuggable by dumping out how many of
> >> these pages there have been somewhere.  That can wait, though, until we
> >> have some kind of stats coming out of the code (there's nothing now).  A
> >> comment to remind us to do this would be nice.
> > Eh, having debugged these several times, the WARN_ONCE in sgx_reset_epc_page()
> > is probably sufficient.  IIRC, when I hit this, things were either laughably
> > broken and every page was failing, or there was another ENCLS failure somewhere
> > else that provided additional info.  Not saying don't add more debug info,
> > rather that it's probably not a priority.
> 
> Minimally, I just want a warning that says, "Whoops, I leaked a page".
> Or EREMOVE could even say, "whoops, this *MIGHT* leak a page".
> 
> My beef is mostly that "EREMOVE failed" doesn't tell and end user squat
> about what this means for their system.  At least if we say "leaked",
> they have some inclination that they've got to reboot to get the page back.

Oh yeah, no argument there.
