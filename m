Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E73C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAEF21548
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ssx9hM2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgI1Pyi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgI1Pyi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Sep 2020 11:54:38 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3902FC061755;
        Mon, 28 Sep 2020 08:54:38 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h2so1728678ilo.12;
        Mon, 28 Sep 2020 08:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVGPSPUovgc0Y23DJShhn11Uz/FVeEYO+SSSJn1LJ3o=;
        b=Ssx9hM2ObzgBkZv/NTryYKHFTVD0EaOXq2rFryyfgxQJSsu44+gMlEl3enPTKDucrV
         B3dBgmd62wss8RyxXD+goGRHFm4U0WT/a22l+4uEnw1Qn855+1StCY7YUvaWD+c/UWEn
         poM+GYoBbO90chF+z0q6kzvMlcaAGp5oIF6wqPWXIVQMFD0RoRF5+VT/36X63+hlnOm9
         NsfzRRfAmqrC5DfC05tHNVqL+NCpZm8LgdUKsWNnBOoYUX65mReVtAfdlZFgAVTKbJEU
         biPfnvTUF1JjwjpvS6WsehAiYdmr9zU6Bz3sYbVRKFdo6U1H6RNh8kU6xhPdV+ydi+lo
         PxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVGPSPUovgc0Y23DJShhn11Uz/FVeEYO+SSSJn1LJ3o=;
        b=itvMuNePMTQt4k3JQHDQxFpr5sl0qViL6qE3mQBkhI22s2K52BwZn6w6FTmdDQASSy
         bugSpLo7uIrfBusKnRgPaEpmo1nPsJJD9xitUx6AKSdqVopMUJPVure1406jBhDPTFCa
         Z6l1WSj5gRvUzGJUQULZUeXlBYh0LwXaa6lnqwCHq9wudwHqr6bTKuxRJMgDPdYJ3+xK
         QsLrk7y3TYKAwGPfrT7phxuAzLJJg3pkP+uBEeN8sH/JS7DI5SQ5rGWzevVy9ubBNc4j
         m5NoDhcjrcZ5sxBJuNm8nnVZdl8+QDlEfqTY6ivpZF8YGCCt83UqYDfEPaw94rdb/+02
         AaAg==
X-Gm-Message-State: AOAM530Fc65QdlxVei+viRY8OvIM+hRxDmhl7kSO2UZLnLGTFs6bF4Ca
        OCIBa1SQu5zqQoPMbpdlq3RgczUOPonYTg8TY9U=
X-Google-Smtp-Source: ABdhPJzBbYtkYsjjz2crHkvXucIQCF2Lv8kuXTp2BGrwoD5/FzL7ABH+JNxVVB2Cif6HZbIt1e+pbs0C1wtTcVe4TG8=
X-Received: by 2002:a05:6e02:d06:: with SMTP id g6mr1716472ilj.151.1601308477565;
 Mon, 28 Sep 2020 08:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com> <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
In-Reply-To: <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
From:   "H.J. Lu" <hjl.tools@gmail.com>
Date:   Mon, 28 Sep 2020 08:54:01 -0700
Message-ID: <CAMe9rOrVhQr9ad_4en2D5GTTqDsJGXqszBmscgenn_87mDxvUA@mail.gmail.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     "Yu, Yu-cheng" <yu-cheng.yu@intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        Borislav Petkov <bp@alien8.de>, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 8:43 AM Yu, Yu-cheng <yu-cheng.yu@intel.com> wrote:
>
> On 9/25/2020 11:23 AM, Andrew Cooper wrote:
> > On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> >> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >> new file mode 100644
> >> index 000000000000..adbd59d41517
> >> --- /dev/null
> >> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >> @@ -0,0 +1,157 @@
> >> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >> <snip>
> >> +.Lretpoline:
> >> +    call    2f
> >> +1:  pause
> >> +    lfence
> >> +    jmp     1b
> >> +2:  mov     %rax, (%rsp)
> >> +    ret
> >
> > I hate to throw further spanners in the work, but this is not compatible
> > with CET, and the user shadow stack work in progress.
>
> Hi Jarkko,
>
> These 1: and 2: targets are reached only from these few lines?  If they
> are direct call/jmp targets, I think it is OK in terms of CET.  If they
> are reached from an instruction like "jmp *%rax", then we need to put in
> an "endbr64".
>

This also isn't compatible with shadow stack.

-- 
H.J.
