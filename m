Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED21BC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E4E2065F
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEnsvt67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgENTFr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 15:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727926AbgENTFq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 14 May 2020 15:05:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E47C061A0E
        for <linux-sgx@vger.kernel.org>; Thu, 14 May 2020 12:05:46 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n17so3732101ejh.7
        for <linux-sgx@vger.kernel.org>; Thu, 14 May 2020 12:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3tnon885BClw24KtSQO83UeeP0neoUdjMWWIznWI9/0=;
        b=mEnsvt67Bs+ijyGbEbYpmFzdKllOnYkYg2wqyJn5b8oZl+W2YcNusKGLRP9+Zv71aD
         bvnpNRlwm3n+nu/MfpFkeS29wmAqit1EIdY/5xYvN2+YHW5w1w9QzfKUAhu1z//b5FyV
         k7dGKz/gm2cwJDUdsjcAGnnZvIUs7DSgpSuU6dsJTiO54rNsE0omiR6rvOq+1m4zvUKk
         N2zTBxT+XyvQS/pazILhd2ryi6MMD4lCcnDv7gM9ufWdCfkhqBBALDBfJo5ZiNRNFLMF
         xssG0X9eIu48mho9U/h+tzq0gpyyTRyeOIE9nztgGi41aWzm4DOSTjaKMqC54Fvnv3Gb
         KttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3tnon885BClw24KtSQO83UeeP0neoUdjMWWIznWI9/0=;
        b=kJA73j0HFyCVQcJUomnw1jeFDggjhBf2uERaBrSkfdCkhWXAO8PD9ik/wDGcRCnV0C
         YEZqLnsm42cC29+WbxYs/VhvKw9aHpWehj8LT2gdBqVzMiSCdVupRmP5UGMtSFEyO7Ih
         ifL8kf9Rksh0F07WjkIrPmsiQMPdUWey4tBiqGuLRh10Icrmo2KwK/D6poJlRTxK7NZg
         zXZAXDh+59ON08InnsyeAjebBNAD7AAaV6Vap6qaJMkkUya0TNPLdv5yg9M9QZK4J1QQ
         MIQpL/krTahuARtFtPd3JK4M9ePocXBP9rx44PLJHypWz+XmzHtU91Fg2aB+RvFg/OGs
         Y7eA==
X-Gm-Message-State: AOAM533DEkYxPTTDPn4unBGhiaO4Wh6pP6NYGkuokyQBbI+YHlFI3E1s
        cHr2W1DrXADPv6HyCYyD/dSTH4dDBQWtHfJWJfuWaA==
X-Google-Smtp-Source: ABdhPJyXoPpJjnDEyX65MLtuSaVojJUla6uGMFPpeIL9qaCZ9kWwHdMrb4GwEnIrg9s40Ca65adiOCj7stM0y7lKZ6c=
X-Received: by 2002:a17:906:724b:: with SMTP id n11mr5455125ejk.355.1589483144432;
 Thu, 14 May 2020 12:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200508190813.GP27052@linux.intel.com>
In-Reply-To: <20200508190813.GP27052@linux.intel.com>
From:   Seth Moore <sethmo@google.com>
Date:   Thu, 14 May 2020 12:05:32 -0700
Message-ID: <CAJsHiNx0jnx_zwCuNecci7opgCkxg-FB8UpYvnmubjWdM3fXZQ@mail.gmail.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com,
        David Rientjes <rientjes@google.com>, cedric.xing@intel.com,
        puiterwijk@redhat.com, Anna Sapek <asapek@google.com>,
        Conrad Parker <conradparker@google.com>,
        Keith Moyer <kmoy@google.com>,
        Yaozhang Xu <yaozhangx@google.com>,
        Chen Chen <chenalexchen@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Carmen Hanish <cyhanish@google.com>,
        Kevin Yap <ikeviny@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 8, 2020 at 12:08 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Adding some Google folks to the party.

Thanks, Sean.

> On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.
> >
> > There is a new hardware unit in the processor called Memory Encryption
> > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> > one or many MEE regions that can hold enclave data by configuring them with
> > PRMRR registers.
> >
> > The MEE automatically encrypts the data leaving the processor package to
> > the MEE regions. The data is encrypted using a random key whose life-time
> > is exactly one power cycle.
> >
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> >
> > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> >
> >       cat /proc/cpuinfo  | grep sgx

We applied the v29 patches to Linux 5.6.0, then tested on Xeon(R) E-2186G
with Asylo (http://asylo.dev).

Looks good. All Asylo tests pass.

Tested-by: Seth Moore <sethmo@google.com>
