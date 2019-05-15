Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFE3C04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 20:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E162070D
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557952532;
	bh=lonIHOL7Ap+kfl9T5uZ3da9vJ8adxkY6vHSVJzCp+ZQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1/3630BLVUzQzSdjccakQM57uKlG/O3rvwEgSb9E1/D/L4Rgc1r67uLDnaUfGCpF1
	 7l64KObaRI3U2NxzDKHMzFC5K0tzPFLXaG2Y4VAcyjB62EnD40btCzgtrkT4NDVEhn
	 AbDmWXQ7zs3YuVnUHReku4V1SnMpFDtxMvBS0Ius=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfEOUfa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 16:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfEOUf3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 16:35:29 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5892177B
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 20:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557952528;
        bh=lonIHOL7Ap+kfl9T5uZ3da9vJ8adxkY6vHSVJzCp+ZQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sxe1PHUU4XbuR+tXXBfRMVnF3zxPgwkrKdabmxJBdKlxATn8R601A2FuhVDEXS57Q
         4MBN2WxCxixO3QRj2TZXPqKhReRHdgbvwzuH8svDK+s5t/oh81b8NtiqEeGRjnSEBX
         D2Am/DdTUY3ZQpeGcqmtEwMdOy3akkSoK9QGHxPY=
Received: by mail-wr1-f51.google.com with SMTP id f8so948791wrt.1
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 13:35:27 -0700 (PDT)
X-Gm-Message-State: APjAAAXJuNMOpyEPOgJ2dPtT2iFi3moD2B6roz/5aadJKD2/ZlIEvGzv
        yhd5hJ9njtrJhUR3EeRk5wy+pVnmUMR50a+cvbJnyQ==
X-Google-Smtp-Source: APXvYqy8ElLQiZWZBdNYQb+QMBcNXMeyfSb7qt7WK7UozAoZUQdnF5nB0ZLitp/BruUmurMT7qwYd0XN/O4CcJ+S/Rc=
X-Received: by 2002:a5d:4907:: with SMTP id x7mr15080115wrq.199.1557952526190;
 Wed, 15 May 2019 13:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
In-Reply-To: <alpine.LRH.2.21.1905160543070.19802@namei.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 15 May 2019 13:35:14 -0700
X-Gmail-Original-Message-ID: <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
Message-ID: <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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

On Wed, May 15, 2019 at 12:58 PM James Morris <jmorris@namei.org> wrote:
>
> On Wed, 15 May 2019, Andy Lutomirski wrote:
>
> > There are two issues with how this interacts with LSMs:
> >
> > 1) LSMs might want to be able to whitelist, blacklist, or otherwise
> > restrict what enclaves can run at all.  The current proposal that
> > everyone seems to dislike the least is to have a .sigstruct file on
> > disk that contains a hash and signature of the enclave in a
> > CPU-defined format.  To initialize an enclave, a program will pass an
> > fd to this file, and a new LSM hook can be called to allow or disallow
> > the operation.  In a SELinux context, the idea is that policy could
> > require the .sigstruct file to be labeled with a type like
> > sgx_sigstruct_t, and only enclaves that have a matching .sigstruct
> > with such a label could run.
>
>
> The .sigstruct file is for the CPU to consume, not the kernel correct?

Yes, unless an LSM wants to examine it to make a decision.

>
> How is it bound to the enclave file?

It's not bound to the enclave *file* at all, but it contains a hash
that covers the enclave, so two different files in two different
formats representing exactly the same enclave would get the same hash,
but any change to the enclave would get a different hash.

>
> Why not just use an xattr, like security.sgx ?

Wouldn't this make it so that only someone with CAP_MAC_ADMIN could
install an enclave?  I think that this decision should be left up the
administrator, and it should be easy to set up a loose policy where
anyone can load whatever enclave they want.  That's what would happen
in my proposal if there was no LSM loaded or of the LSM policy didn't
restrict what .sigstruct files were acceptable.

>
> >
> > 2) Just like any other DSO, there are potential issues with how
> > enclaves deal with writable vs executable memory.  This takes two
> > forms.  First, a task should probably require EXECMEM, EXECMOD, or
> > similar permission to run an enclave that can modify its own text.
> > Second, it would be nice if a task that did *not* have EXECMEM,
> > EXECMOD, or similar could still run the enclave if it had EXECUTE
> > permission on the file containing the enclave.
> >
> > Currently, this all works because DSOs are run by mmapping the file to
> > create multiple VMAs, some of which are executable, non-writable, and
> > non-CoWed, and some of which are writable but not executable.  With
> > SGX, there's only really one inode per enclave (the anon_inode that
> > comes form /dev/sgx/enclave), and it can only be sensibly mapped
> > MAP_SHARED.
> >
> > With the current version of the SGX driver, to run an enclave, I think
> > you'll need either EXECUTE rights to /dev/sgx/enclave or EXECMOD or
> > similar, all of which more or less mean that you can run any modified
> > code you want, and none of which is useful to prevent enclaves from
> > contain RWX segments.
> >
> > So my question is: what, if anything, should change to make this work better?
>
> Would it be possible to provide multiple fds (perhaps via a pseudo fs
> interface) which can be mapped to different types of VMAs?

Maybe.  The tricky bit is that, even if there was a separate inode for
the writable and the executable parts of the enclave, I think that
both would have to be mapped MAP_SHARED since MAP_ANONYMOUS is
nonsensical for SGX.  This would certainly push more complexity into
the user code.  Jarkko?
