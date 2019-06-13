Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D4FC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE05C206BB
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfFMQ7r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:59:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:22262 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbfFMAKj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 20:10:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 17:10:38 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jun 2019 17:10:38 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.232]) with mapi id 14.03.0415.000;
 Wed, 12 Jun 2019 17:10:37 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
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
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmAgACMWICAAWfBAIAAKpIA//+YzvA=
Date:   Thu, 13 Jun 2019 00:10:37 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503261@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <CALCETrWQT3AG+-OKBOzuw-a6VPApkNYsKqZiBmS56-b-72bfYQ@mail.gmail.com>
 <20190612220242.GJ20308@linux.intel.com>
In-Reply-To: <20190612220242.GJ20308@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDhmOWQxYWItZGYxOC00NDE5LWI5YmQtMjdkNDE0ZTdmYjVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYmM4cGFEMU03UU9yd1pLVSs0bEU5czk2RUNacmxySk1RU2w5b1puWjlWTkRIQ3BLdnZJeEVoa1VsTHdMV2pJMiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Wednesday, June 12, 2019 3:03 PM
> 
> > I think this model works quite well in an SGX1 world.  The main thing
> > that makes me uneasy about this model is that, in SGX2, it requires
> > that an SGX2-compatible enclave loader must pre-declare to the kernel
> > whether it intends for its dynamically allocated memory to be
> > ALLOW_EXEC.  If ALLOW_EXEC is set but not actually needed, it will
> > still fail if DENY_X_IF_ALLOW_WRITE ends up being set.  The other
> > version below does not have this limitation.
> 
> I'm not convinced this will be a meaningful limitation in practice,
> though that's probably obvious from my RFCs :-).  That being said, the
> UAPI quirk is essentially a dealbreaker for multiple people, so let's
> drop #1.
> 
> I discussed the options with Cedric offline, and he is ok with option #2
> *if* the idea actually translates to acceptable code and doesn't present
> problems for userspace and/or future SGX features.
> 
> So, I'll work on an RFC series to implement #2 as described below.  If
> it works out, yay!  If not, i.e. option #2 is fundamentally broken, I'll
> shift my focus to Cedric's code (option #3).
> 
> > >   2. Pre-check LSM permissions and dynamically track mappings to
> enclave
> > >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> > >      based on the pre-checked permissions.
> > >
> > >      Pros: Does not impact SGX UAPI, medium kernel complexity
> > >      Cons: Auditing is complex/weird, requires taking enclave-
> specific
> > >            lock during mprotect() to query/update tracking.
> >
> > Here's how this looks in my mind.  It's quite similar, except that
> > ALLOW_READ, ALLOW_WRITE, and ALLOW_EXEC are replaced with a little
> > state machine.
> >
> > EADD does not take any special flags.  It calls this LSM hook:
> >
> >   int security_enclave_load(struct vm_area_struct *source);
> >
> > This hook can return -EPERM.  Otherwise it 0 or
> > ALLOC_EXEC_IF_UNMODIFIED (i.e. 1).  This hook enforces permissions (a)
> and (b).
> >
> > The driver tracks a state for each page, and the possible states are:
> >
> >  - CLEAN_MAYEXEC /* no W or X VMAs have existed, but X is okay */
> >  - CLEAN_NOEXEC /* no W or X VMAs have existed, and X is not okay */
> >  - CLEAN_EXEC /* no W VMA has existed, but an X VMA has existed */
> >  - DIRTY /* a W VMA has existed */
> >
> > The initial state for a page is CLEAN_MAYEXEC if the hook said
> > ALLOW_EXEC_IF_UNMODIFIED and CLEAN_NOEXEC otherwise.
> >
> > The future EAUG does not call a hook at all and puts pages into the
> > state CLEAN_NOEXEC.  If SGX3 or later ever adds EAUG-but-don't-clear,
> > it can call security_enclave_load() and add CLEAN_MAYEXEC pages if
> appropriate.
> >
> > EINIT takes a sigstruct pointer.  SGX calls a new hook:
> >
> >   unsigned int security_enclave_init(struct sigstruct *sigstruct,
> > struct vm_area_struct *source, unsigned int flags);
> >
> > This hook can return -EPERM.  Otherwise it returns 0 or a combination
> > of flags DENY_WX and DENY_X_DIRTY.  The driver saves this value.
> > These represent permissions (c) and (d).
> >
> > If we want to have a permission for "execute code supplied from
> > outside the enclave that was not measured", we could have a flag like
> > HAS_UNMEASURED_CLEAN_EXEC_PAGE that the LSM could consider.
> >
> > mmap() and mprotect() enforce the following rules:
> >
> >  - If VM_EXEC is requested and (either the page is DIRTY or VM_WRITE
> is
> >    requested) and DENY_X_DIRTY, then deny.
> >
> >  - If VM_WRITE and VM_EXEC are both requested and DENY_WX, then deny.
> >
> >  - If VM_WRITE is requested, we need to update the state.  If it was
> >    CLEAN_EXEC, then we reject if DENY_X_DIRTY.  Otherwise we change
> the
> >    state to DIRTY.
> >
> >  - If VM_EXEC is requested and the page is CLEAN_NOEXEC, then deny.
> >
> > mprotect() and mmap() do *not* call SGX-specific LSM hooks to ask for
> > permission, although they can optionally call an LSM hook if they hit
> > one of the -EPERM cases for auditing purposes.
> >
> > Before the SIGSTRUCT is provided to the driver, the driver acts as
> > though DENY_X_DIRTY and DENY_WX are both set.

I think we've been discussing 2 topics simultaneously, one is the state machine that accepts/rejects mmap/mprotect requests, while the other is where is the best place to put it. I think we have an agreement on the former, and IMO option #2 and #3 differ only in the latter.

Option #2 keeps the state machine inside SGX subsystem, so it could reuse existing data structures for page tracking/locking to some extent. Sean may have smarter ideas, but it looks to me like the existing 'struct sgx_encl_page' tracks individual enclave pages while the FSM states apply to ranges. So in order *not* to test page by page in mmap/mprotect, I guess some new range oriented structures are still necessary. But I don't think it very important anyway. 

My major concern is more from the architecture/modularity perspective. Specifically, the state machine is defined by LSM but SGX does the state transitions. That's a brittle relationship that'd break easily if the state machine changes in future, or if different LSM modules want to define different FSMs (comprised of different set of states and/or triggers). After all, what's needed by the SGX subsystem is just the decision, not the FSM definition. I think we should take a closer look at this area once Sean's patch comes out.

