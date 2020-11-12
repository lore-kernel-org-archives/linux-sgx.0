Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D865C2D0E4
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0984F22250
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="teH4Qyhw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgKLWlP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLWlP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:41:15 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0635F22253
        for <linux-sgx@vger.kernel.org>; Thu, 12 Nov 2020 22:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605220874;
        bh=TIUppCALNwaHlE5rK5c0ydSZxnQCuBpff8wpCFgyPXE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=teH4Qyhw8xsxYmB8MLkP7Of2tY8v+nEIlr8OA0TEL7K2Ue1KY0Z3iTsgrEQY7gA32
         h5CTD3PWMJKbTZKMqLiKbfA6b3kT0XE4NVZbPwYBIlxFUdZcAB78PsmaOuZ09rERXX
         1YBE1h6O51V7CFjQsaFlVG1nUc8HRuxI+HRSGIes=
Received: by mail-wm1-f45.google.com with SMTP id 10so6585620wml.2
        for <linux-sgx@vger.kernel.org>; Thu, 12 Nov 2020 14:41:13 -0800 (PST)
X-Gm-Message-State: AOAM532y1Pqq0dRGzX+JwfeQ6dKfKMQDAkLE8h/zepDYwiYrhICQhiAK
        UxM4hSGjl5qdWHlXxK3CmuHeddDaUyof5svHBcaT1g==
X-Google-Smtp-Source: ABdhPJwjDJ5n6cZYqwYLuSjOEw1F3mMY5MAOPzOD3AxIPaeWfMnaswzLgqo3yGilV0Z1PSDHO7VmDptEJa3o6gGkW78=
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr44938wmg.21.1605220872356;
 Thu, 12 Nov 2020 14:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com>
 <20201107150930.GA29530@wind.enjellic.com> <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com>
 <20201112205819.GA9172@wind.enjellic.com> <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com>
In-Reply-To: <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 12 Nov 2020 14:41:00 -0800
X-Gmail-Original-Message-ID: <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com>
Message-ID: <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com>
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 12, 2020 at 1:31 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 11/12/20 12:58 PM, Dr. Greg wrote:
> > @@ -270,11 +270,10 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
> >                           struct vm_area_struct **pprev, unsigned long start,
> >                           unsigned long end, unsigned long newflags)
> >  {
> > -     int ret;
> > +     struct sgx_encl *encl = vma->vm_private_data;
> >
> > -     ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> > -     if (ret)
> > -             return ret;
> > +     if ( test_bit(SGX_ENCL_INITIALIZED, &encl->flags) )
> > +             return -EACCES;
> >
> >       return mprotect_fixup(vma, pprev, start, end, newflags);
> >  }
>
> This rules out mprotect() on running enclaves.  Does that break any
> expectations from enclave authors, or take away capabilities that folks
> need?

It certainly prevents any scheme in which an enclave coordinates with
the outside world to do W-and-then-X JIT inside.  I'm also not
convinced it has any real effect at all unless there's some magic I
missed to prevent someone from using mmap(2) to effectively change
permissions.

Everyone, IMO this SGX1 - vs - SGX2 - vs - EDMM discussion is entirely
missing the point and is a waste of everyone's time.  Let's pretend
we're building a system that has nothing to do with SGX and requires
no special hardware support at all.  It works like this:

A user program opens /dev/xyz and gets back an fd that represents 16
MB of memory.  The user program copies some data from disk (or network
or whatever) into fd (using write(2) or ioctl(2) or mmap(2) and
memcpy) and then mmaps some of the fd as R and some as RW and some as
RX, and then the user program jumps into the RX mapping.

If we replace /dev/xyz with /dev/zero, then this simply does not work
under a reasonably strict W^X policy -- a lot of people think it's
quite reasonable for an OS to prevent a user program from obtaining an
X mapping containing anything other than a mapping from a file on
disk.  To solve this, we can do one of at least three things:

a) You can't use /dev/xyz unless you have permission to create WX
memory or to at least create W memory and then change it to X.

b) You can do whatever you want with /dev/xyz, and LSM policies are
blatantly violated as a result.

c) The /dev/xyz API is clever and tracks, page-by-page, whether the
user intends to ever write and/or execute that page, and behaves
accordingly.

This patchset takes the approach (c).  The actual clever policy isn't
here yet, and we don't really know whether it will ever appear, but
the API is set up to enable such a policy to be written.  This appears
to be a win for everyone, since the code is pretty clean and the API
is straightforward.


Now, back to SGX.  There are only two things that are remotely
SGX-specific here.  First, SGX requires this unusual memory model in
which there is an executable mapping of (part of) a device node. [0]
Second, early SGX hardware had this oddity that the kernel could set a
per-backing-page (as opposed to per-PTE) bit to permanently disable X
on a given /dev/sgx page.  Building a security model around that would
have been a hack, and it DOES NOT WORK on new hardware.  So can we
please stop discussing it?  None of the actual interesting parts of
this have much to do with SGX per se and have nothing whatsoever to do
with EDMM or any other Intel buzzword.

Heck, if anyone actually cared to do so, something with essentially
the same semantics could probably be built using SEV hardware instead
of SGX, and it would have exactly the same issue if we wanted it to
work for tasks that didn't have access to /dev/kvm.


[0] SGX doesn't *really* require this.  We could set things up so that
you do mmap(..., MAP_ANONYMOUS, fd, ...) and then somehow introduce
that mapping to SGX.  I think the result would be too disgusting to
seriously consider.
