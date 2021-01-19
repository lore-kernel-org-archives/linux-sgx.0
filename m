Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE63C433E6
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEB2423104
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 18:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387973AbhASStL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 13:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390961AbhASSEC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jan 2021 13:04:02 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D912C061574
        for <linux-sgx@vger.kernel.org>; Tue, 19 Jan 2021 10:03:22 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id b3so12748334pft.3
        for <linux-sgx@vger.kernel.org>; Tue, 19 Jan 2021 10:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v6Cc6phhfBsgyLf8+xyS43H+OQ51FWLRN6lfb6Q8ovM=;
        b=aLIWjMflFoQyuawhdmxoalCHnIknslDW1bgG9bYBifymBMTGMpV8sRRBs3fL7Z2bYa
         LzjWQlWOfPGOYbERaLoAE5rcgPJxXfFD+ck3EF3GFdQz04Y/0OAIEIyr0u6+gP5fwE1v
         IpZxGzBT6/NtDsni4J1QaP6osdwd0MG6lpKGh3K0LJg6xCyh1ic1JVpvrwFNaaIwwUBY
         kczFAjJTcUM959+HivOPMqEvOJw0+dnGZRSnUEQE0KXJ+7o0qOHJiqibGvDmt6LA41gw
         cUWv6MYZKl8EZOGJKhfdMJTweo/nPce8TcCEqvOyf4jGM9p8Cn24q+CMYO3ip5UbrLjV
         IUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v6Cc6phhfBsgyLf8+xyS43H+OQ51FWLRN6lfb6Q8ovM=;
        b=qmVCTKvoH56QoM03Z1ANDKrTGLu8issOW5FwY+W/R/HZJY+5u3MrzzmaHugkNVycCq
         7XE+FlK0w7ZKLOxahbCzg0Z/wUNK3R+AbqKkIw0AbjDDAzB4g3iCkTMFf5Im8sbdwWdx
         6R/8etfulg0Ie0A9OpJmMGo1jJnSganxwN4Cbw0c4vig/vO0ntpZYHloFPlDj7Cp2t6I
         jEeLI8YeXAZm9U1K2pYvXE+yqjpDmfvlT11mBORZBE3l0J+khYDw9OkPiLpDDjDB/jYQ
         gwI4Pwae2lstbkYK9gKHtzms7HkObOptqEDII7FWKBJsLvYUw8qwm+OKrev5f55XEU4F
         ppRA==
X-Gm-Message-State: AOAM531R5ZZ3oAgziMFwP5WqWa2ReDifp44X67uIVm5fXOBHRnJkjlXV
        OEOlVGppdMJJpxhvKK/zvQwSrw==
X-Google-Smtp-Source: ABdhPJzQQf5xl4oyoV+n4TOdJD/nLHTXZuyEtbWz5VXTrNXH0br4vzS/T+YHSd9mZjIKdkACeRW0Hw==
X-Received: by 2002:a05:6a00:2286:b029:1ae:6c7f:31ce with SMTP id f6-20020a056a002286b02901ae6c7f31cemr5099392pfe.6.1611079401581;
        Tue, 19 Jan 2021 10:03:21 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id t206sm18718982pgb.84.2021.01.19.10.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 10:03:20 -0800 (PST)
Date:   Tue, 19 Jan 2021 10:03:14 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YAce4r4QhGzJqd4y@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
 <20210119161925.GN27433@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119161925.GN27433@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 19, 2021, Borislav Petkov wrote:
> On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > index 3b1b01f2b248..7937a315f8cf 100644
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -96,7 +96,6 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
> >  static void clear_sgx_caps(void)
> >  {
> >  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> > -	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> 
> Why is that line being removed here?
> 
> Shouldn't this add SGX1 and SGX2 here instead as this function is
> supposed to, well, *clear* sgx caps on feat_ctl setup failures or
> "nosgx" cmdline?

Doesn't adding making the SGX sub-features depend on X86_FEATURE_SGX have the
same net effect?  Or am I misreading do_clear_cpu_cap()?

Though if we use the cpuid_deps table, I'd vote to get rid of clear_sgx_caps()
and call setup_clear_cpu_cap(X86_FEATURE_SGX) directly.  And probably change the
existing SGX_LC behavior and drop clear_sgx_caps() in a separate patch instead
of squeezing it into this one.
