Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC08C28CC6
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 957D72085A
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559679380;
	bh=UUD8js2GAwr4II2RKampxullfYCdUCEzAhpMSNle0/Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zWmiFBW6w/iOdSGAqFKrHtasDOYEBtQUb7xiXPGmyNfNicdoDi42YhfDgLhqPQfoB
	 CxyEtdlSyP+ynt9hIt7ZQSuSbZ+HyCvDcuZO9+++HWICUbMK+QS/WeWjX0b3ySgHKy
	 XYbacAdllTIhOEqS+8mG5qsSZK5otpFs0OZIbl7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFDUQT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfFDUQS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:16:18 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42E4C21019
        for <linux-sgx@vger.kernel.org>; Tue,  4 Jun 2019 20:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559679377;
        bh=UUD8js2GAwr4II2RKampxullfYCdUCEzAhpMSNle0/Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RGzP2rSxHLkPNvO6s5zF9RmhMr7ron36rvZeXufXGabhAl0HSmZSVK6VEGGL94SxR
         JSGRwOIr5m3QWD+LmSqNETKHpFBN+ZXFxG9AvOUE4/QVjjDZ8s6FBraiWEYrwtUWL8
         DezGQaioxI4qhrTSbuv0eYVn7NjF5biPe7ZXpPBo=
Received: by mail-wm1-f49.google.com with SMTP id f10so50149wmb.1
        for <linux-sgx@vger.kernel.org>; Tue, 04 Jun 2019 13:16:17 -0700 (PDT)
X-Gm-Message-State: APjAAAWwZm7Sg1Q3PQGkbDylMOuNBcH+FutMdVIfGqV1cCF6ATG/rhxF
        NjFQ6L2wro5N8Aa4qpYa/tnscO+kMrUg4Hx/lGvaKw==
X-Google-Smtp-Source: APXvYqxKLARYLnWrB9GjRsqdH0CB/G7w6TKwEtytC9EXxuJZ2IVSsZsrGcb61zvu/E7Rk143AaRVLPJumcYr3E2cHZg=
X-Received: by 2002:a1c:6242:: with SMTP id w63mr15836829wmb.161.1559679375566;
 Tue, 04 Jun 2019 13:16:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-3-sean.j.christopherson@intel.com> <20190604114951.GC30594@linux.intel.com>
In-Reply-To: <20190604114951.GC30594@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 4 Jun 2019 13:16:04 -0700
X-Gmail-Original-Message-ID: <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
Message-ID: <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] x86/sgx: Do not naturally align MAP_FIXED address
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 4, 2019 at 4:50 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Fri, May 31, 2019 at 04:31:52PM -0700, Sean Christopherson wrote:
> > SGX enclaves have an associated Enclave Linear Range (ELRANGE) that is
> > tracked and enforced by the CPU using a base+mask approach, similar to
> > how hardware range registers such as the variable MTRRs.  As a result,
> > the ELRANGE must be naturally sized and aligned.
> >
> > To reduce boilerplate code that would be needed in every userspace
> > enclave loader, the SGX driver naturally aligns the mmap() address and
> > also requires the range to be naturally sized.  Unfortunately, SGX fails
> > to grant a waiver to the MAP_FIXED case, e.g. incorrectly rejects mmap()
> > if userspace is attempting to map a small slice of an existing enclave.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Why you want to allow mmap() to be called multiple times? mmap() could
> be allowed only once with PROT_NONE and denied afterwards. Is this for
> sending fd to another process that would map already existing enclave?
>
> I don't see any checks for whether the is enclave underneath. Also, I
> think that in all cases mmap() callback should allow only PROT_NONE
> as permissions for clarity even if it could called multiple times.
>

What's the advantage to only allowing PROT_NONE?  The idea here is to
allow a PROT_NONE map followed by some replacemets that overlay it for
the individual segments.  Admittedly, mprotect() can do the same
thing, but disallowing mmap() seems at least a bit surprising.
