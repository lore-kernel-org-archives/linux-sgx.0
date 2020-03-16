Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902EEC0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 17:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6719620679
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 17:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbgCPRRW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 13:17:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:43559 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbgCPRRV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 13:17:21 -0400
IronPort-SDR: K0NB5rVmdkiD58MEQBWI20B9/8Kb6THDSk7m3h1NPUXrHod7hX11HxSICBQSzS5+KpNnzQfsx+
 P2paUghjYf4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 10:17:21 -0700
IronPort-SDR: 89TgovsS+wPctmLe6qcX+9E9bZjgh4/kNBdZIB0o8siPkvfm83eMykN5LNt5gdjNSIopsgoopy
 tNRuQLIl4mIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="237673369"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2020 10:17:20 -0700
Date:   Mon, 16 Mar 2020 10:17:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200316171720.GG24267@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
 <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
 <db12016d-8719-daa0-4742-7d7c43dd464d@fortanix.com>
 <CAOASepNZZ8rGmJNvSdFHbtYpJkfkHp4vAdDFOmR4BcuOcCRgNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepNZZ8rGmJNvSdFHbtYpJkfkHp4vAdDFOmR4BcuOcCRgNQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 16, 2020 at 10:03:31AM -0400, Nathaniel McCallum wrote:
> On Mon, Mar 16, 2020 at 9:59 AM Jethro Beekman <jethro@fortanix.com> wrote:
> >
> > On 2020-03-16 14:57, Nathaniel McCallum wrote:
> > > On Mon, Mar 16, 2020 at 9:32 AM Jethro Beekman <jethro@fortanix.com> wrote:
> > >>
> > >> On 2020-03-15 18:53, Nathaniel McCallum wrote:
> > >>> On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
> > >>> <jarkko.sakkinen@linux.intel.com> wrote:
> > >>>>
> > >>>> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> > >>>>> Currently, the selftest has a wrapper around
> > >>>>> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> > >>>>> registers (CSRs), though it uses none of them. Then it calls this
> > >>>>> function which uses %rbx but preserves none of the CSRs. Then it jumps
> > >>>>> into an enclave which zeroes all these registers before returning.
> > >>>>> Thus:
> > >>>>>
> > >>>>>   1. wrapper saves all CSRs
> > >>>>>   2. wrapper repositions stack arguments
> > >>>>>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
> > >>>>>   4. selftest zeros all CSRs
> > >>>>>   5. wrapper loads all CSRs
> > >>>>>
> > >>>>> I'd like to propose instead that the enclave be responsible for saving
> > >>>>> and restoring CSRs. So instead of the above we have:
> > >>>>>   1. __vdso_sgx_enter_enclave() saves %rbx
> > >>>>>   2. enclave saves CSRs
> > >>>>>   3. enclave loads CSRs
> > >>>>>   4. __vdso_sgx_enter_enclave() loads %rbx
> > >>>>>
> > >>>>> I know that lots of other stuff happens during enclave transitions,
> > >>>>> but at the very least we could reduce the number of instructions
> > >>>>> through this critical path.
> > >>>>
> > >>>> What Jethro said and also that it is a good general principle to cut
> > >>>> down the semantics of any vdso as minimal as possible.
> > >>>>
> > >>>> I.e. even if saving RBX would make somehow sense it *can* be left
> > >>>> out without loss in terms of what can be done with the vDSO.
> > >>>
> > >>> Please read the rest of the thread. Sean and I have hammered out some
> > >>> sensible and effective changes.
> > >>
> > >> I'm not sure they're sensible? By departing from the ENCLU calling
> > >> convention, both the VDSO and the wrapper become more complicated.
> > >
> > > For the vDSO, only marginally. I'm counting +4,-2 instructions in my
> > > suggestions. For the wrapper, things become significantly simpler.
> > >
> > >> The wrapper because now it needs to implement all kinds of logic for
> > >> different behavior depending on whether the VDSO is or isn't available.

How so?  The wrapper, if one is needed, will need to have dedicated logic
for the vDSO no matter what interface is defined by the vDSO.  Taking the
leaf in %rcx instead of %rax would at worst add a single instruction.  At
best, it would eliminate the wrapper entirely by making the vDSO callable
from C, e.g. for enclaves+runtimes that treat EENTER/ERESUME as glorified
function calls, i.e. more or less follow the x86-64 ABI.

> > > When isn't the vDSO available?
> >
> > When you're not on Linux. Or when you're on an old kernel.
> 
> I fail to see why the Linux kernel should degrade its new interfaces for
> those use cases.

There are effectively four related, but independent, changes to consider:

  1. Make the RSP fixup in the "return from handler" path relative instead
     of absolute.

  2. Preserve RBX in the vDSO.

  3. Use %rcx instead of %rax to pass @leaf.

  4. Allow the untrusted runtime to pass a parameter directly to its exit
     handler.


For me, #1 is an easy "yes".  It's arguably a bug fix, and the cost is one
uop.

My vote for #2 and #3 would also be a strong "yes".  Although passing @leaf
in %rcx technically diverges from ENCLU, I actually think it will make it
easier to swap between the vDSO and a bare ENCLU.  E.g. have the prototype
for the vDSO be the prototype for the assembly wrapper:

typedef void (*enter_enclave_fn)(unsigned long rdi, unsigned long rsi,
				 unsigned long rdx, unsigned int leaf,
				 unsigned long r8,  unsigned long r9,
				 void *tcs,
				 struct sgx_enclave_exception *e,
				 sgx_enclave_exit_handler_t handler);

int run_enclave(...)
{
	enter_enclave_fn enter_enclave;

	if (vdso)
		enter_enclave = vdso;
	else
		enter_enclave = my_wrapper;
	return enter_enclave(...);
}


I don't have a strong opinion on #4.  It seems superfluous, but if the
parameter is buried at the end of the prototype then it can be completely
ignored by runtimes that don't utilize a handler.
