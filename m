Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECA2C4741F
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B0B206C9
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601335241;
	bh=x2tvT8zp4CBxz7nAU7LyLPETPAu+I6Ua1JlXWrtLOZc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OSA2e6OCekhVazNnvn7J9LW84UKgz48CW366qze4v2MSoELoliKfiQrpLEulUBdZg
	 PPOs1WGHevtsrJBjAfBImRGyX/PtPQ8rAnVAKRaxtG6BaWiIezGK+rKdX0C31jN9Ed
	 hBpGT25fdKM3/n5dI39mrzNAo8ryngfQpEsrGbD0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgI1XUg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgI1XUc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 19:20:32 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107E723A5F
        for <linux-sgx@vger.kernel.org>; Mon, 28 Sep 2020 22:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601332902;
        bh=x2tvT8zp4CBxz7nAU7LyLPETPAu+I6Ua1JlXWrtLOZc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iixT9zzEJHDBXywk9K/foiJl4tE081SAMjHm3MiHBJ45nj31cG04XGlWFEPtJCR9v
         KibXxqRX0dfaB66jP7vHj3eLnB672rgBDtVdEyEKWHZ/PrTsuGbX7r2/QHxrMAQnll
         q7xNIENGfB6Xa4+fJgI7nt8OcQW7tcRZShJRTMdo=
Received: by mail-wr1-f52.google.com with SMTP id k15so3027601wrn.10
        for <linux-sgx@vger.kernel.org>; Mon, 28 Sep 2020 15:41:41 -0700 (PDT)
X-Gm-Message-State: AOAM5306r4IbWo/lq1+qch2VniJQunqxgmBib80HuSphLn8zI6W1omMP
        YfZ7DLqXOOUmOE2Tia95fVqH2/uDzJUAE3BG4av+7Q==
X-Google-Smtp-Source: ABdhPJyNrKbQCmxlsPs1zBqlDEV9hKHXLrdJR/SFTZofDAMtjOyWnj17QVmEn/Y6N9FX/YvXnD1KKJMBySAkveebaNY=
X-Received: by 2002:adf:a3c3:: with SMTP id m3mr704595wrb.70.1601332900365;
 Mon, 28 Sep 2020 15:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com> <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com> <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
 <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com>
 <20200928215635.GF2705@linux.intel.com> <CAMe9rOoyxtf_kUCdb-TN+NmZsQNmFY8NLMObSdCB5bBVq1x+cQ@mail.gmail.com>
 <24b9f250-0f75-1a7d-688d-787ca53b388c@intel.com>
In-Reply-To: <24b9f250-0f75-1a7d-688d-787ca53b388c@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Sep 2020 15:41:28 -0700
X-Gmail-Original-Message-ID: <CALCETrViotikw5HcDnvuY8nm28bAcdMQjcVs88kXVf8sjb0C_w@mail.gmail.com>
Message-ID: <CALCETrViotikw5HcDnvuY8nm28bAcdMQjcVs88kXVf8sjb0C_w@mail.gmail.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "H.J. Lu" <hjl.tools@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 3:18 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 9/28/20 3:06 PM, H.J. Lu wrote:
> >> I'm open to do either solution. My thinking was to initially do things
> >> vsgx.S local (i.e. consider ALTERNATIVE post upstreaming) and use the
> >> above solution but I'm also fine doing ALTERNATIVE. Dave kindly briefed
> >> on details how that thing works and it should be perfectly usable for
> >> our use case.
> >>
> > Since SHSTK and IBT are enabled per process, not the whole machine,
> > are you going to patch vDSO on a per-process basis?
>
> No.
>
> Retpolines mitigate Spectre v2 attacks.  If you're not vulnerable to
> Spectre v2, you don't need retpolines.
>
> All processors which support CET *also* have hardware mitigations
> against Spectre v2 and don't need retpolines.  Here's all of the
> possibilities:
>
> CET=y, BUG_SPECTRE_V2=y: does not exist
> CET=n, BUG_SPECTRE_V2=y: vulnerable, use retpoline
> CET=y, BUG_SPECTRE_V2=n: no retpoline, not vulnerable
> CET=n, BUG_SPECTRE_V2=n: no retpoline, not vulnerable

Just to confirm: does this mean that the CPU mitigates against user
code mistraining the branch predictors for CPL0?  Because this is the
vDSO, and the situation we're actually concerned about is user code
mistraining its own branch predictors.  This could happen
cross-process or within the same process.
