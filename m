Return-Path: <SRS0=kShl=TK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE54AC04A6B
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 19:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A33112184E
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 19:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557516169;
	bh=A5xalmmL8H1Iq8fxzTQYLZUEYrOLdpg9dk/dWsknQFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tv3D8eFumEC69u7kNSUpWC+5556bGImm9GhKwGgmFh8/+qlyjb1ZmRBNGRNORUl7D
	 etFWXd4nJTe+OzlH9gSpktfBJbvTVX3hOzD6oUEH+0Yu0wg9DsRbgJlC1qTqam1riN
	 vcBMNl7zKVmSNDq7so5pu4IB4K5JGjz/wm2p0o2w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfEJTWt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 May 2019 15:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfEJTWt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 May 2019 15:22:49 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A683521874
        for <linux-sgx@vger.kernel.org>; Fri, 10 May 2019 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557516167;
        bh=A5xalmmL8H1Iq8fxzTQYLZUEYrOLdpg9dk/dWsknQFI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0M9qAGAC0+oIV4vU1pOYOruimjxIP6xwN3M4zU10h4UPjIztj0OG/SpZtik8pMLt9
         GDVz56oQ/ShGKiiIkHgo46c1UWx/bmxdxMhi2Ex6TH+6PlfJKb7xwrbG2R2hgWUs57
         /t859446qfSlRWpK6BDlgEN29nRE0WIXUkSmwb0U=
Received: by mail-wr1-f49.google.com with SMTP id v11so9056154wru.5
        for <linux-sgx@vger.kernel.org>; Fri, 10 May 2019 12:22:47 -0700 (PDT)
X-Gm-Message-State: APjAAAVa9cFK/0S/3EcJiz59fisdIQMWM97zkhm83J3OAT65/k8GZ/GT
        QZooCLG/Jix8QEnRP4Y7Cv5Vu7nkvhz0gXGtKwfXag==
X-Google-Smtp-Source: APXvYqzwrq2r4B9dU7/lca9s9tWpGlVr6bah8EziTqKYJ7y9XqMUfvQCNcoAPzJ5b+KqOLhKhXMzWEEQSpXISygfQak=
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr8719136wrs.309.1557516166095;
 Fri, 10 May 2019 12:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com> <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com> <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
In-Reply-To: <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 10 May 2019 12:22:34 -0700
X-Gmail-Original-Message-ID: <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
Message-ID: <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 10, 2019 at 12:04 PM Jethro Beekman <jethro@fortanix.com> wrote=
:
>
> On 2019-05-10 11:56, Xing, Cedric wrote:
> > Hi Jethro,
> >
> >> ELF files are explicitly designed such that you can map them (with mma=
p)
> >> in 4096-byte chunks. However, sometimes there's overlap and you will
> >> sometimes see that a particular offset is mapped twice because the fir=
st
> >> half of the page in the file belongs to an RX range and the second hal=
f
> >> to an R-only range. Also, ELF files don't (normally) describe stack,
> >> heap, etc. which you do need for enclaves.
> >
> > You have probably misread my email. By mmap(), I meant the enclave file=
 would be mapped via *multiple* mmap() calls, in the same way as what dlope=
n() would do in loading regular shared object. The intention here is to mak=
e the enclave file subject to the same checks as regular shared objects.
>
> No, I didn't misread your email. My original point still stands:
> requiring that an enclave's memory is created from one or more mmap
> calls of a file puts significant restrictions on the enclave's on-disk
> representation.
>

For a tiny bit of background, Linux (AFAIK*) makes no effort to ensure
the complete integrity of DSOs.  What Linux *does* do (if so
configured) is to make sure that only approved data is mapped
executable.  So, if you want to have some bytes be executable, those
bytes have to come from a file that passes the relevant LSM and IMA
checks.  So we have two valid approaches, I think.

Approach 1: we treat SGX exactly the same way and make it so that only
bytes that pass the relevant checks can be mapped as code within an
enclave.  This imposes no particular restrictions on the file format
-- we just need some API that takes an fd, an offset, and a length,
and adds those bytes as code to an enclave.  (It could also take a
pointer and a length and make sure that the pointer points to
executable memory -- same effect.)

Approach 2: we decide that we want a stronger guarantee and that we
*will* ensure the integrity of the enclave.  This means:

2a) that we either need to load the entire thing from some approved
file, and we commit to supporting one or more file formats.

2b) we need to check that the eventual enclave hash is approved.  Or
we could have a much shorter file that is just the hash and we check
that.  At its simplest, the file could be *only* the hash, and there
could be an LSM callback to check it.  In the future, if someone wants
to allow enclaves to be embedded in DSOs, we could have a special ELF
note or similar that contains an enclave hash or similar.

2c) same as 2b except that we expose the whole SIGSTRUCT, not just the hash=
.

Here are some pros and cons of various bits:

1 and 2a allow anti-virus software to scan the enclave code, and 2a
allows it to scan the whole enclave.  I don't know if this is actually
imporant.

2a is by far the most complicated kernel implementation.

2b and 2c are almost file-format agnostic.  1 is completely file
format agnostic but, in exchange, it's much weaker.

2b and 2c should solve most (but not all) of the launch control
complaints that Dr. Greg cares about, in the sense that the LSM policy
quite literally validates that the enclave is approved.

As a straw man design, I propose the following, which is mostly 2c.
The whole loading process works almost as in Jarkko's current driver,
but the actual ioctl that triggers EINIT changes.  When you issue the
ioctl, you pass in an fd and the SIGSTRUCT is loaded and checked from
the fd.  The idea is that software that ships an enclave will ship a
.sgxsig file that is literally a SIGSTRUCT for the enclave.  With
SELinux, that file gets labeled something like
sgx_enclave_sigstruct_t.  And we have the following extra twist: if
you're calling the EADD ioctl to add *code* to the enclave, the driver
checks that the code being loaded is mapped executable.  This way
existing code-signing policies don't get subverted, and policies that
want to impose full verification on the enclave can do so by verifying
the .sigstruct file.

What do you all think?

* It's certainly the case that Linux does not *succeed* at preserving
the overall integrity of shared objects.  If nothing else, you can
freely mremap() them however you like.  And you can jump into them
wherever you like.
