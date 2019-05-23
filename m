Return-Path: <SRS0=njgX=TX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CD3C282DD
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 15:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C7C2177E
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558625916;
	bh=In3rvS7qPiwg1FJyBh5dflvbEpFMS5hBT03hiE9/rvA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=HLtZIpJlQKudFKjoMJQQqaxmQ3JnYFgbfF/JsdGZSVoaH4U5k+TiY1HNhBG9JX5/c
	 LZW7nnO7NeITqPyOhYGHHL2fHfUbLK6UoybupaUtbcZBMKgjyXtLbwkyAWUE3MQL3s
	 x/EDB2VTokcjf3IPou3TTca745+UsXdN6zq43Y5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfEWPif (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 May 2019 11:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbfEWPic (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 May 2019 11:38:32 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E40B21883
        for <linux-sgx@vger.kernel.org>; Thu, 23 May 2019 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558625911;
        bh=In3rvS7qPiwg1FJyBh5dflvbEpFMS5hBT03hiE9/rvA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xk6zSVVym0P5KzT42cddxpF5yiXdUhUa7xXOH8MpCn/cfJ3S5vsZrZR1o+iH6sGKX
         hkrXhHaIakfO9PQJ7lGcW4W7NPRcZPL0drDouwMn9s5QqGCuu2jZjFp4+Z07wrOi7k
         YHcRad0Pul+hudp7zzagXr+enMDf8Rtwvcy617Ek=
Received: by mail-wm1-f48.google.com with SMTP id y3so6351538wmm.2
        for <linux-sgx@vger.kernel.org>; Thu, 23 May 2019 08:38:31 -0700 (PDT)
X-Gm-Message-State: APjAAAXlhXS0oMrtogQDSbPrhZaTWgfhKCzC76WI2kyretmk8J8uBuYo
        AOE45pVCUrP0v5MgTuNEFRuuTNhcShiIukExGh53VQ==
X-Google-Smtp-Source: APXvYqy++PtcXnqHwArqj5UBHapLbM3bluHIFIybhJhiF3cxodhKIK1g6g8QRkLstCYhKG/XwAU/aSxLQ8voK78SKUw=
X-Received: by 2002:a1c:9c42:: with SMTP id f63mr13030971wme.23.1558625909476;
 Thu, 23 May 2019 08:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190520114105.GD27805@linux.intel.com> <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com> <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com> <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com> <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
In-Reply-To: <20190523141752.GA12078@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 23 May 2019 08:38:17 -0700
X-Gmail-Original-Message-ID: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
Message-ID: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
> > On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
> > > But actually, there's no need to disallow mmap() after ECREATE since the
> > > LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
> > > mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
> > > bypassed LSM checks?  The real problem is that mmap()'ng an existing
> > > enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
> > > at square one.
> >
> > I'm lost with the constraints we want to set.
>
> As is today, SELinux policies would require enclave loaders to have
> FILE__WRITE and FILE__EXECUTE permissions on /dev/sgx/enclave.  Presumably
> other LSMs have similar requirements.  Requiring all processes to have
> FILE__{WRITE,EXECUTE} permissions means the permissions don't add much
> value, e.g. they can't be used to distinguish between an enclave that is
> being loaded from an unmodified file and an enclave that is being
> generated on the fly, e.g. Graphene.
>
> Looking back at Andy's mail, he was talking about requiring FILE__EXECUTE
> to run an enclave, so perhaps it's only FILE__WRITE that we're trying to
> special case.
>

I thought about this some more, and I have a new proposal that helps
address the ELRANGE alignment issue and the permission issue at the
cost of some extra verbosity.  Maybe you all can poke holes in it :)
The basic idea is to make everything more explicit from a user's
perspective.  Here's how it works:

Opening /dev/sgx/enclave gives an enclave_fd that, by design, doesn't
give EXECUTE or WRITE.  mmap() on the enclave_fd only works if you
pass PROT_NONE and gives the correct alignment.  The resulting VMA
cannot be mprotected or mremapped.  It can't be mmapped at all until
after ECREATE because the alignment isn't known before that.

Associated with the enclave are a bunch (up to 7) "enclave segment
inodes".  These are anon_inodes that are created automagically.  An
enclave segment is a group of pages, not necessary contiguous, with an
upper bound on the memory permissions.  Each enclave page belongs to a
segment.  When you do EADD, you tell the driver what segment you're
adding to. [0]  This means that EADD gets an extra argument that is a
permission mask for the page -- in addition to the initial SECINFO,
you also pass to EADD something to the effect of "I promise never to
map this with permissions greater than RX".

Then we just need some way to mmap a region from an enclave segment.
This could be done by having a way to get an fd for an enclave segment
or it could be done by having a new ioctl SGX_IOC_MAP_SEGMENT.  User
code would use this operation to replace, MAP_FIXED-style, ranges from
the big PROT_NONE mapping with the relevant pages from the enclave
segment.  The resulting vma would only have VM_MAYWRITE if the segment
is W, only have VM_MAYEXEC if the segment is X, and only have
VM_MAYREAD if the segment is R.  Depending on implementation details,
the VMAs might need to restrict mremap() to avoid mapping pages that
aren't part of the segment in question.

It's plausible that this whole thing works without the magic segment
inodes under the hood, but figuring that out would need a careful look
at how all the core mm bits and LSM bits work together.

To get all the LSM stuff to work, SELinux will need some way to
automatically assign an appropriate label to the segment inodes.  I
assume that such a mechanism already exists and gets used for things
like sockets, but I haven't actually confirmed this.

[0] There needs to be some vaguely intelligent semantics if you EADD
the *same* address more than once.  A simple solution would be to
disallow it if the segments don't match.
