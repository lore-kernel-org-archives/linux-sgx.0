Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8425C31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 19:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A890521721
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560367837;
	bh=h97diiQWZdqlQ81qSsUGwG2qdx36A24rBfkQNgw4pQ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=TZW7TsHhbpf/ZCOwxuXD18NgKQqABy33ocgE5LuilhxlFRWUt3/GylcMN4kTF4Pef
	 zmZ8F76jOVsodzInqJRcPfuWHQvwvyyH1Lh4UiQibbQXVaz2t/VxOvRvdi86rEeyJf
	 MfdzooS8J2rnsGCg4letVl6NusY+HnfoJd0zQwQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388221AbfFLTah (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 15:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbfFLTae (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 15:30:34 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F28302184B
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jun 2019 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560367833;
        bh=h97diiQWZdqlQ81qSsUGwG2qdx36A24rBfkQNgw4pQ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xJ7yPAzUSlkMtjigoey8f3HD7f2j2VMqn1jhFRs+98+1cqkoZQoCEBwu5gzhVt9cc
         F5kGVgP8s2X8+KQHtHgKMItJGDqoSSqqdmnBPl+RwWoBP0jeLhhg1kkOGnvJp1urK8
         MiOP81oFlPpupcIvzjzcwC5Fx2+Hv/eN8ycVUclk=
Received: by mail-wr1-f43.google.com with SMTP id b17so18132995wrq.11
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jun 2019 12:30:32 -0700 (PDT)
X-Gm-Message-State: APjAAAWXHr0eq9chMIzXRP2LFov4OwXqFpzKuzQIpyzwX7esfchwsVrj
        F32cG5kLhOOld7YVZ/77IfY6QAiFBs30RbcCDnQc2w==
X-Google-Smtp-Source: APXvYqy5x9diLPrcbhstS+YVuX+XWQq7iMhNri6eT6+sEnq4gVyZpAWeu8P1fKqxN6m8gPIB0E36q2gXd5KXDiLulq8=
X-Received: by 2002:adf:ef48:: with SMTP id c8mr34810713wrp.352.1560367831343;
 Wed, 12 Jun 2019 12:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com>
In-Reply-To: <20190611220243.GB3416@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 12 Jun 2019 12:30:20 -0700
X-Gmail-Original-Message-ID: <CALCETrWQT3AG+-OKBOzuw-a6VPApkNYsKqZiBmS56-b-72bfYQ@mail.gmail.com>
Message-ID: <CALCETrWQT3AG+-OKBOzuw-a6VPApkNYsKqZiBmS56-b-72bfYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        pmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 11, 2019 at 3:02 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> > I haven't looked at this code closely, but it feels like a lot of
> > SGX-specific logic embedded into SELinux that will have to be repeated or
> > reused for every security module.  Does SGX not track this state itself?
>
> SGX does track equivalent state.
>
> There are three proposals on the table (I think):

Sounds about right.  I've been playing with #1 and #2 (as text, not
code), and I'll post my latest thoughts on it below.  But first, I
should mention that I think we've gotten a bit too caught up on
SELinux-y terminology like "EXECMOD" and "EXECMEM", which is relevant
since the kernel has very little visibility into what the enclave is
doing.  Instead, I think we should think about the relevant
permissions more like this:

a) "execute code from a particular source, e.g. a file"
b) "execute code supplied from arbitrary memory outside the enclave"
c) "execute code generated within the enclave"
d) "possess WX enclave memory"

I think that any sensible policy that allows (b) should allow (a).
Similarly, any policy that allows (d) should allow (c).   I don't see
any particular need for the kernel to go out of its way to ensure
these relationships, though.

We could plausibly also distinguish "execute measured code", although
I think that the details of defining and implenenting this, especially
with SGX2, could be nastier than we want to deal with.  A minimal
approach that mostly ignores SGX2 would be to have another permission
"execute code supplied from outside the enclave that was not
measured".  This permission would be required on top of (a) or (b),
depending on where that code comes from.

If we want to map these to existing SELinux terms, we could use
EXECUTE for (a), EXECMOD for (c), and EXECMEM for (d). (b) seems to
also map to EXECMOD or EXECMEM depending on exactly how it happens,
and I'm not sure this makes all that much sense.

>
>   1. Require userspace to explicitly specificy (maximal) enclave page
>      permissions at build time.  The enclave page permissions are provided
>      to, and checked by, LSMs at enclave build time.
>
>      Pros: Low-complexity kernel implementation, straightforward auditing
>      Cons: Sullies the SGX UAPI to some extent, may increase complexity of
>            SGX2 enclave loaders.

In my notes, this works like this.  This is similar, but not
identical, to what Sean has been sending out.

EADD takes flags: ALLOW_READ, ALLOW_WRITE, ALLOW_EXEC.  It calls a new hook:

  int security_enclave_load(struct vm_area_struct *source, unsigned int flags);

(Sean passed in the secinfo protection too, but I think we agreed
that this could be omitted.)  This hook will fail if ALLOW_EXEC is
requested and the LSM doesn't consider the source VMA to be
executable.  Privileges (a) and (b) are implemented here.

Optionally, we can enforce noexec here.

The future EAUG ioctl takes the same flags, but it doesn't call
security_enclave_load().  (As Cedric noted, the actual user API for EAUG
is not settled, but I don't think it makes much difference here.)

EINIT takes a sigstruct pointer.  SGX calls a new hook:

  unsigned int security_enclave_init(struct sigstruct *sigstruct,
struct vm_area_struct *source, unsigned int flags);

This hook can return -EPERM.  Otherwise it returns 0 or a combination of
flags DENY_WX and DENY_X_IF_ALLOW_WRITE.  The driver saves this value.
These represent permissions (c) and (d).

If we want to have a permission for "execute code supplied from
outside the enclave that was not measured", we could have a flag like
HAS_UNMEASURED_ALLOW_EXEC_PAGE that the LSM could consider.

mmap() and mprotect() enforce the following rules:

 - Deny if a PROT_ flag is requested but the corresponding ALLOW_ flag
   is not set for all pages in question.

 - Deny if PROT_WRITE, PROT_EXEC, and DENY_WX are all set.

 - Deny if PROT_EXEC, ALLOW_WRITE, and DENY_X_IF_ALLOW_WRITE are all set.

mprotect() and mmap() do *not* call SGX-specific LSM hooks to ask for
permission, although they can optionally call an LSM hook if they hit one of
the -EPERM cases for auditing purposes.


I think this model works quite well in an SGX1 world.  The main thing
that makes me uneasy about this model is that, in SGX2, it requires
that an SGX2-compatible enclave loader must pre-declare to the kernel
whether it intends for its dynamically allocated memory to be
ALLOW_EXEC.  If ALLOW_EXEC is set but not actually needed, it will
still fail if DENY_X_IF_ALLOW_WRITE ends up being set.  The other
version below does not have this limitation.

>
>   2. Pre-check LSM permissions and dynamically track mappings to enclave
>      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
>      based on the pre-checked permissions.
>
>      Pros: Does not impact SGX UAPI, medium kernel complexity
>      Cons: Auditing is complex/weird, requires taking enclave-specific
>            lock during mprotect() to query/update tracking.

Here's how this looks in my mind.  It's quite similar, except that
ALLOW_READ, ALLOW_WRITE, and ALLOW_EXEC are replaced with a little
state machine.

EADD does not take any special flags.  It calls this LSM hook:

  int security_enclave_load(struct vm_area_struct *source);

This hook can return -EPERM.  Otherwise it 0 or ALLOC_EXEC_IF_UNMODIFIED
(i.e. 1).  This hook enforces permissions (a) and (b).

The driver tracks a state for each page, and the possible states are:

 - CLEAN_MAYEXEC /* no W or X VMAs have existed, but X is okay */
 - CLEAN_NOEXEC /* no W or X VMAs have existed, and X is not okay */
 - CLEAN_EXEC /* no W VMA has existed, but an X VMA has existed */
 - DIRTY /* a W VMA has existed */

The initial state for a page is CLEAN_MAYEXEC if the hook said
ALLOW_EXEC_IF_UNMODIFIED and CLEAN_NOEXEC otherwise.

The future EAUG does not call a hook at all and puts pages into the state
CLEAN_NOEXEC.  If SGX3 or later ever adds EAUG-but-don't-clear, it can
call security_enclave_load() and add CLEAN_MAYEXEC pages if appropriate.

EINIT takes a sigstruct pointer.  SGX calls a new hook:

  unsigned int security_enclave_init(struct sigstruct *sigstruct,
struct vm_area_struct *source, unsigned int flags);

This hook can return -EPERM.  Otherwise it returns 0 or a combination of
flags DENY_WX and DENY_X_DIRTY.  The driver saves this value.
These represent permissions (c) and (d).

If we want to have a permission for "execute code supplied from outside the
enclave that was not measured", we could have a flag like
HAS_UNMEASURED_CLEAN_EXEC_PAGE that the LSM could consider.

mmap() and mprotect() enforce the following rules:

 - If VM_EXEC is requested and (either the page is DIRTY or VM_WRITE is
   requested) and DENY_X_DIRTY, then deny.

 - If VM_WRITE and VM_EXEC are both requested and DENY_WX, then deny.

 - If VM_WRITE is requested, we need to update the state.  If it was
   CLEAN_EXEC, then we reject if DENY_X_DIRTY.  Otherwise we change the
   state to DIRTY.

 - If VM_EXEC is requested and the page is CLEAN_NOEXEC, then deny.

mprotect() and mmap() do *not* call SGX-specific LSM hooks to ask for
permission, although they can optionally call an LSM hook if they hit one of
the -EPERM cases for auditing purposes.

Before the SIGSTRUCT is provided to the driver, the driver acts as though
DENY_X_DIRTY and DENY_WX are both set.
