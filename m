Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EADC31E4A
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8B0C21743
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbfFMRM6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 13:12:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:33800 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfFLWCq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 18:02:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 15:02:43 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 12 Jun 2019 15:02:42 -0700
Date:   Wed, 12 Jun 2019 15:02:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190612220242.GJ20308@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <CALCETrWQT3AG+-OKBOzuw-a6VPApkNYsKqZiBmS56-b-72bfYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWQT3AG+-OKBOzuw-a6VPApkNYsKqZiBmS56-b-72bfYQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 12, 2019 at 12:30:20PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 11, 2019 at 3:02 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> >   1. Require userspace to explicitly specificy (maximal) enclave page
> >      permissions at build time.  The enclave page permissions are provided
> >      to, and checked by, LSMs at enclave build time.
> >
> >      Pros: Low-complexity kernel implementation, straightforward auditing
> >      Cons: Sullies the SGX UAPI to some extent, may increase complexity of
> >            SGX2 enclave loaders.
> 
> In my notes, this works like this.  This is similar, but not
> identical, to what Sean has been sending out.

...

> mmap() and mprotect() enforce the following rules:
> 
>  - Deny if a PROT_ flag is requested but the corresponding ALLOW_ flag
>    is not set for all pages in question.
> 
>  - Deny if PROT_WRITE, PROT_EXEC, and DENY_WX are all set.
> 
>  - Deny if PROT_EXEC, ALLOW_WRITE, and DENY_X_IF_ALLOW_WRITE are all set.
> 
> mprotect() and mmap() do *not* call SGX-specific LSM hooks to ask for
> permission, although they can optionally call an LSM hook if they hit one of
> the -EPERM cases for auditing purposes.

IMO, #1 only makes sense if it's stripped down to avoid auditing and
locking complications, i.e. gets a pass/fail at security_enclave_load()
and clears VM_MAY* flags during mmap().  If we want WX and W->X to be
differentiated by security_enclave_init() as opposed to
security_enclave_load(), then we should just scrap #1.

> I think this model works quite well in an SGX1 world.  The main thing
> that makes me uneasy about this model is that, in SGX2, it requires
> that an SGX2-compatible enclave loader must pre-declare to the kernel
> whether it intends for its dynamically allocated memory to be
> ALLOW_EXEC.  If ALLOW_EXEC is set but not actually needed, it will
> still fail if DENY_X_IF_ALLOW_WRITE ends up being set.  The other
> version below does not have this limitation.

I'm not convinced this will be a meaningful limitation in practice, though
that's probably obvious from my RFCs :-).  That being said, the UAPI quirk
is essentially a dealbreaker for multiple people, so let's drop #1.

I discussed the options with Cedric offline, and he is ok with option #2
*if* the idea actually translates to acceptable code and doesn't present
problems for userspace and/or future SGX features.

So, I'll work on an RFC series to implement #2 as described below.  If it
works out, yay!  If not, i.e. option #2 is fundamentally broken, I'll
shift my focus to Cedric's code (option #3).

> >   2. Pre-check LSM permissions and dynamically track mappings to enclave
> >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> >      based on the pre-checked permissions.
> >
> >      Pros: Does not impact SGX UAPI, medium kernel complexity
> >      Cons: Auditing is complex/weird, requires taking enclave-specific
> >            lock during mprotect() to query/update tracking.
> 
> Here's how this looks in my mind.  It's quite similar, except that
> ALLOW_READ, ALLOW_WRITE, and ALLOW_EXEC are replaced with a little
> state machine.
> 
> EADD does not take any special flags.  It calls this LSM hook:
> 
>   int security_enclave_load(struct vm_area_struct *source);
> 
> This hook can return -EPERM.  Otherwise it 0 or ALLOC_EXEC_IF_UNMODIFIED
> (i.e. 1).  This hook enforces permissions (a) and (b).
> 
> The driver tracks a state for each page, and the possible states are:
> 
>  - CLEAN_MAYEXEC /* no W or X VMAs have existed, but X is okay */
>  - CLEAN_NOEXEC /* no W or X VMAs have existed, and X is not okay */
>  - CLEAN_EXEC /* no W VMA has existed, but an X VMA has existed */
>  - DIRTY /* a W VMA has existed */
> 
> The initial state for a page is CLEAN_MAYEXEC if the hook said
> ALLOW_EXEC_IF_UNMODIFIED and CLEAN_NOEXEC otherwise.
> 
> The future EAUG does not call a hook at all and puts pages into the state
> CLEAN_NOEXEC.  If SGX3 or later ever adds EAUG-but-don't-clear, it can
> call security_enclave_load() and add CLEAN_MAYEXEC pages if appropriate.
> 
> EINIT takes a sigstruct pointer.  SGX calls a new hook:
> 
>   unsigned int security_enclave_init(struct sigstruct *sigstruct,
> struct vm_area_struct *source, unsigned int flags);
> 
> This hook can return -EPERM.  Otherwise it returns 0 or a combination of
> flags DENY_WX and DENY_X_DIRTY.  The driver saves this value.
> These represent permissions (c) and (d).
> 
> If we want to have a permission for "execute code supplied from outside the
> enclave that was not measured", we could have a flag like
> HAS_UNMEASURED_CLEAN_EXEC_PAGE that the LSM could consider.
>
> mmap() and mprotect() enforce the following rules:
> 
>  - If VM_EXEC is requested and (either the page is DIRTY or VM_WRITE is
>    requested) and DENY_X_DIRTY, then deny.
> 
>  - If VM_WRITE and VM_EXEC are both requested and DENY_WX, then deny.
> 
>  - If VM_WRITE is requested, we need to update the state.  If it was
>    CLEAN_EXEC, then we reject if DENY_X_DIRTY.  Otherwise we change the
>    state to DIRTY.
> 
>  - If VM_EXEC is requested and the page is CLEAN_NOEXEC, then deny.
> 
> mprotect() and mmap() do *not* call SGX-specific LSM hooks to ask for
> permission, although they can optionally call an LSM hook if they hit one of
> the -EPERM cases for auditing purposes.
> 
> Before the SIGSTRUCT is provided to the driver, the driver acts as though
> DENY_X_DIRTY and DENY_WX are both set.

