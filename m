Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B6CC04AB5
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 01:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DEF2243D6
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 01:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFDBgv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 21:36:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:1742 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFDBgv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 21:36:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 18:36:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 03 Jun 2019 18:36:50 -0700
Date:   Mon, 3 Jun 2019 18:36:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Message-ID: <20190604013650.GC24521@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
 <20190603171549.GE13384@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 03, 2019 at 11:30:54AM -0700, Xing, Cedric wrote:
> > From: Christopherson, Sean J
> > Sent: Monday, June 03, 2019 10:16 AM
> > 
> > On Sun, Jun 02, 2019 at 12:29:35AM -0700, Xing, Cedric wrote:
> > > Hi Sean,
> > >
> > > Generally I agree with your direction but think ALLOW_* flags are
> > > completely internal to LSM because they can be both produced and
> > > consumed inside an LSM module. So spilling them into SGX driver and
> > > also user mode code makes the solution ugly and in some cases
> > > impractical because not every enclave host process has a priori
> > > knowledge on whether or not an enclave page would be EMODPE'd at
> > runtime.
> > 
> > In this case, the host process should tag *all* pages it *might* convert
> > to executable as ALLOW_EXEC.  LSMs can (and should/will) be written in
> > such a way that denying ALLOW_EXEC is fatal to the enclave if and only
> > if the enclave actually attempts mprotect(PROT_EXEC).
> 
> What if those pages contain self-modifying code but the host doesn't know
> ahead of time? Would it require ALLOW_WRITE|ALLOW_EXEC at EADD? Then would it
> prevent those pages to start with PROT_EXEC?

Without ALLOW_WRITE+ALLOW_EXEC, the enclave would build and launch, but
fail at mprotect(..., PROT_WRITE), e.g. when it attempted to gain write
access to do self-modifying code.  And it would would fail irrespective of
LSM restrictions.

> Anyway, my point is that it is unnecessary even if it works.

Unnecessary in an ideal world, yes.  Realistically, it's the least bad
option.

> > Take the SELinux path for example.  The only scenario in which
> > PROT_WRITE is cleared from @allowed_prot is if the page *starts* with
> > PROT_EXEC.
> > If PROT_EXEC is denied on a page that starts RW, e.g. an EAUG'd page,
> > then PROT_EXEC will be cleared from @allowed_prot.
> > 
> > As Stephen pointed out, auditing the denials on @allowed_prot means the
> > log will contain false positives of a sort.  But this is more of a noise
> > issue than true false positives.  E.g. there are three possible outcomes
> > for the enclave.
> > 
> >   - The enclave does not do EMODPE[PROT_EXEC] in any scenario, ever.
> >     Requesting ALLOW_EXEC is either a straightforward a userspace bug or
> >     a poorly written generic enclave loader.
> > 
> >   - The enclave conditionally performs EMODPE[PROT_EXEC].  In this case
> >     the denial is a true false positive.
> > 
> >   - The enclave does EMODPE[PROT_EXEC] and its host userspace then fails
> >     on mprotect(PROT_EXEC), i.e. the LSM denial is working as intended.
> >     The audit log will be noisy, but viewed as a whole the denials
> > aren't
> >     false positives.
> 
> What I was talking about was EMODPE[PROT_WRITE] on an RX page.

As above, mprotect(..., PROT_WRITE) would fail without ALLOW_WRITE.

> > The potential for noisy audit logs and/or false positives is unfortunate,
> > but it's (by far) the lesser of many evils.
> > 
> > > Theoretically speaking, what you really need is a per page flag (let's
> > > name it WRITTEN?) indicating whether a page has ever been written to
> > > (or more precisely, granted PROT_WRITE), which will be used to decide
> > > whether to grant PROT_EXEC when requested in future. Given the fact
> > > that all mprotect() goes through LSM and mmap() is limited to
> > > PROT_NONE, it's easy for LSM to capture that flag by itself instead of
> > asking user mode code to provide it.
> > >
> > > That said, here is the summary of what I think is a better approach.
> > > * In hook security_file_alloc(), if @file is an enclave, allocate some
> > data
> > >   structure to store for every page, the WRITTEN flag as described
> > above.
> > >   WRITTEN is cleared initially for all pages.
> > 
> > This would effectively require *every* LSM to duplicate the SGX driver's
> > functionality, e.g. track per-page metadata, implement locking to
> > prevent races between multiple mm structs, etc...
> 
> Architecturally we shouldn't dictate how LSM makes decisions. ALLOW_* are no
> difference than PROCESS__* or FILE__* flags, which are just artifacts to
> assist particular LSMs in decision making. They are never considered part of
> the LSM interface, even if other LSMs than SELinux may adopt the same/similar
> approach.

No, the flags are tracked and managed by SGX.  We are not dictating LSM
behavior in any way, e.g. an LSM could completely ignore @allowed_prot and
nothing would break.

> If code duplication is what you are worrying about, you can put them in a
> library, or implement/export them in some new file (maybe
> security/enclave.c?) as utility functions.

Code duplication is the least of my concerns.  Tracking file pointers
would require a global list/tree of some form, along with a locking and/or
RCU scheme to protect accesses to that container.  Another lock would be
needed to prevent races between mprotect() calls from different processes.

> But spilling them into user mode is what I think is unacceptable.

Why is it unacceptable?  There's effectively no cost to userspace for SGX1.
The ALLOW_* flags only come into play in the event of a noexec or LSM
restriction, i.e. worst case scenario an enclave that wants to do arbitrary
self-modifying code can declare RWX on everything.
